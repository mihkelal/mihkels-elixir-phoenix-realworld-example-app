defmodule RealWorldWeb.UserController do
  use RealWorldWeb, :controller

  alias RealWorld.Account
  alias RealWorld.Account.User

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:show]

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params),
         {:ok, jwt} <- Account.encode_and_sign_user_id(user) do
      conn
      |> put_status(:created)
      |> render("show.json", jwt: jwt, user: user)
    else
      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RealWorldWeb.UserView, "error.json", message: message)
    end
  end

  def show(conn, _params) do
    user = conn.assigns.current_user
    token = RealWorldWeb.Guardian.Plug.current_token(conn)

    render(conn, "show.json", jwt: token, user: user)
  end

  def update(conn, %{} = user_params) do
    user = conn.assigns.current_user

    case Account.update_user(user, user_params) do
      {:ok, user} ->
        token = RealWorldWeb.Guardian.Plug.current_token(conn)
        render(conn, "show.json", jwt: token, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RealWorldWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
