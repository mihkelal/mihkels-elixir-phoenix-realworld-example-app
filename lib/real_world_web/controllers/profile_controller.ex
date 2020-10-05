defmodule RealWorldWeb.ProfileController do
  use RealWorldWeb, :controller

  alias RealWorld.Account.User

  action_fallback RealWorldWeb.FallbackController

  def show(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user -> render(conn, "show.json", user: user)
      nil -> send_resp(conn, 404, "")
    end
  end
end
