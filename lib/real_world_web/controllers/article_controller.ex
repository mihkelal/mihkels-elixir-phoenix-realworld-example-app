defmodule RealWorldWeb.ArticleController do
  use RealWorldWeb, :controller

  alias RealWorld.CMS

  action_fallback RealWorldWeb.FallbackController

  def index(conn, %{"limit" => limit, "offset" => offset} = params) do
    articles = CMS.list_articles(author: params["author"], limit: limit, offset: offset)

    render(conn, "index.json", articles: articles)
  end
end
