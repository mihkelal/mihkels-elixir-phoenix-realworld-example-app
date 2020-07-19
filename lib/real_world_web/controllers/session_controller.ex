defmodule RealWorldWeb.SessionController do
  use RealWorldWeb, :controller

  alias RealWorld.Account

  action_fallback RealWorldWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    case Account.authenticate_user(user_params) do
      {:ok, user, jwt} ->
        conn
        |> put_status(:created)
        |> render(RealWorldWeb.UserView, "login.json", user: user, jwt: jwt)
      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(RealWorldWeb.UserView, "error.json", message: message)
    end
  end
end
