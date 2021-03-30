defmodule RealWorldWeb.TagController do
  use RealWorldWeb, :controller

  alias RealWorld.CMS

  action_fallback(RealWorldWeb.FallbackController)

  def index(conn, _params) do
    render(conn, "index.json", tags: CMS.list_tags())
  end
end
