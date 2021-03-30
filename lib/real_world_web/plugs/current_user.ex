defmodule RealWorldWeb.Plugs.CurrentUser do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _options) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, user)
  end
end
