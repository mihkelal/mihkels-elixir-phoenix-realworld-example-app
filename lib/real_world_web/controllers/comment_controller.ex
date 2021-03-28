defmodule RealWorldWeb.CommentController do
  use RealWorldWeb, :controller

  alias RealWorld.Repo
  alias RealWorld.CMS

  action_fallback RealWorldWeb.FallbackController

  def index(conn, %{"article_slug" => article_slug} = _params) do
    comments =
      article_slug
      |> CMS.get_article_by_slug!()
      |> CMS.list_comments_by_article()

    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"article_slug" => article_slug, "comment" => comment_params} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)
    article = CMS.get_article_by_slug!(article_slug)

    case CMS.create_comment(
           Map.merge(comment_params, %{"user_id" => user.id, "article_id" => article.id})
         ) do
      {:ok, comment} ->
        render(conn, "show.json", comment: Repo.preload(comment, :user))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)

    comment =
      id
      |> String.to_integer()
      |> CMS.get_comment!()
      |> Repo.preload(:user)

    with true <- user == comment.user,
         {:ok, comment} <- CMS.delete_comment(comment) do
      render(conn, "show.json", comment: comment)
    else
      false ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "You can only delete your own comments")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end
end
