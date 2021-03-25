defmodule RealWorldWeb.CommentController do
  use RealWorldWeb, :controller

  alias RealWorld.CMS

  action_fallback RealWorldWeb.FallbackController

  def index(conn, %{"article_slug" => article_slug} = _params) do
    comments =
      article_slug
      |> CMS.get_article_by_slug!()
      |> CMS.list_comments_by_article()

    render(conn, "index.json", comments: comments)
  end
end
