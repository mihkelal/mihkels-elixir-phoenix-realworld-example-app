defmodule RealWorldWeb.ArticleController do
  use RealWorldWeb, :controller

  alias RealWorld.Repo
  alias RealWorld.CMS
  alias RealWorld.CMS.Article

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:feed, :create]

  def index(conn, %{"limit" => limit, "offset" => offset} = params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)

    articles =
      CMS.list_articles(%{author: params["author"], favorited: params["favorited"], limit: limit, offset: offset})
      |> CMS.load_favorites(user)

    render(conn, "index.json", articles: articles)
  end

  def show(conn, %{"slug" => slug} = _params) do
    case CMS.get_article_by_slug!(slug) do
      %Article{} = article -> render(conn, "show.json", article: article)
      nil -> send_resp(conn, 404, "")
    end
  end

  def create(conn, %{"article" => article_params} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)

    article_params = Map.put(article_params, "user_id", user.id)

    case CMS.create_article(article_params) do
      {:ok, article} ->
        conn
        |> put_status(:created)
        |> render("show.json", article: Repo.preload(article, :user))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end

  def update(conn, %{"slug" => slug, "article" => article_params} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)
    article = CMS.get_article_by_slug!(slug)

    with true <- user == article.user,
         {:ok, article} <- CMS.update_article(article, article_params) do
      conn
      |> render("show.json", article: Repo.preload(article, :user))
    else
      false ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "You can only change your own articles")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end

  def delete(conn, %{"slug" => slug} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)
    article = CMS.get_article_by_slug!(slug)

    with true <- user == article.user,
         {:ok, article} <- CMS.delete_article(article) do
      render(conn, "show.json", article: Repo.preload(article, :user))
    else
      false ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "You can only delete your own articles")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end

  def feed(conn, %{"limit" => limit, "offset" => offset} = _params) do
    current_user = RealWorldWeb.Guardian.Plug.current_resource(conn)

    articles =
      CMS.list_feed(%{user: current_user, limit: limit, offset: offset})
      |> CMS.load_favorites(current_user)

    render(conn, "index.json", articles: articles)
  end

  def favorite(conn, %{"article_slug" => article_slug} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)
    article = CMS.get_article_by_slug!(article_slug)

    case CMS.favorite_article(user, article) do
      {:ok, _favorite} ->
        article =
          article
          |> Repo.preload([:user, :favorites])
          |> CMS.load_favorite(user)

        render(conn, "show.json", article: Repo.preload(article, :user))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end

  def unfavorite(conn, %{"article_slug" => article_slug} = _params) do
    user = RealWorldWeb.Guardian.Plug.current_resource(conn)
    article = CMS.get_article_by_slug!(article_slug)

    with true <- user == article.user,
         {:ok, _favorite} <- CMS.unfavorite_article(user, article) do
      article =
        article
        |> Repo.preload([:user, :favorites])
        |> CMS.load_favorite(user)

      render(conn, "show.json", article: Repo.preload(article, :user))
    else
      false ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: "You can only unfavorite your own articles")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: inspect(changeset.errors))
    end
  end
end
