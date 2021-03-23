defmodule RealWorldWeb.ArticleController do
  use RealWorldWeb, :controller

  alias RealWorld.CMS
  alias RealWorld.CMS.Article

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:feed]

  def index(conn, %{"limit" => limit, "offset" => offset} = params) do
    articles = CMS.list_articles(%{author: params["author"], limit: limit, offset: offset})

    render(conn, "index.json", articles: articles)
  end

  def show(conn, %{"slug" => slug} = _params) do
    case CMS.get_article_by_slug!(slug) do
      %Article{} = article -> render(conn, "show.json", article: article)
      nil -> send_resp(conn, 404, "")
    end
  end

  def feed(conn, %{"limit" => limit, "offset" => offset} = _params) do
    current_user = RealWorldWeb.Guardian.Plug.current_resource(conn)

    articles = CMS.list_feed(%{user: current_user, limit: limit, offset: offset})

    render(conn, "index.json", articles: articles)
  end
end
