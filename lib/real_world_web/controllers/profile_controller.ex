defmodule RealWorldWeb.ProfileController do
  use RealWorldWeb, :controller

  alias RealWorld.Account
  alias RealWorld.Account.User

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:follow]

  def show(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user ->
        current_user = RealWorldWeb.Guardian.Plug.current_resource(conn)

        render(conn, "show.json", user: user, following: Account.follows?(current_user, user))

      nil ->
        send_resp(conn, 404, "")
    end
  end

  def follow(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user ->
        current_user = RealWorldWeb.Guardian.Plug.current_resource(conn)

        case Account.follow(current_user, user) do
          {:ok, _following} ->
            render(conn, "show.json", user: user, following: true)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", message: inspect(changeset.errors))
        end

      nil ->
        send_resp(conn, 404, "")
    end
  end

  def unfollow(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user ->
        current_user = RealWorldWeb.Guardian.Plug.current_resource(conn)

        case Account.unfollow(current_user, user) do
          {:ok, _following} ->
            render(conn, "show.json", user: user, following: false)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", message: inspect(changeset.errors))
        end

      nil ->
        send_resp(conn, 404, "")
    end
  end
end
