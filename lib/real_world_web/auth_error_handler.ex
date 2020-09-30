defmodule RealWorldWeb.AuthErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, reason}, _opts) do
    conn
    |> Plug.Conn.put_status(:forbidden)
    |> Phoenix.Controller.render(RealWorldWeb.UserView, "error.json", message: reason)
  end
end
