defmodule RealWorldWeb.SessionController do
  use RealWorldWeb, :controller

  alias RealWorld.Account

  action_fallback RealWorldWeb.FallbackController

  def create(conn, %{"user" => login_params}) do
    case Account.find_user_and_check_password(login_params) do
      {:ok, user} ->
        case Account.encode_and_sign_user_id(user) do
          {:ok, jwt} ->
            conn
            |> put_status(:created)
            |> render(RealWorldWeb.UserView, "login.json", user: user, jwt: jwt)

          {:error, message} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(RealWorldWeb.UserView, "error.json", message: message)
        end

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render(RealWorldWeb.UserView, "error.json", message: message)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> render(RealWorldWeb.UserView, "error.json", message: "not authenticated")
  end
end
