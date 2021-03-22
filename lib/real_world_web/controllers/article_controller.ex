defmodule RealWorldWeb.ArticleController do
  use RealWorldWeb, :controller

  alias RealWorld.CMS

  action_fallback RealWorldWeb.FallbackController

  def index(conn, %{"limit" => limit, "offset" => offset} = _params) do
    articles =
      conn
      |> RealWorldWeb.Guardian.Plug.current_resource()
      |> CMS.list_user_articles(limit: limit, offset: offset)

    render(conn, "index.json", articles: articles)
  end
end
