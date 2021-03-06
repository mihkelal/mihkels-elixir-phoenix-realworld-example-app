defmodule RealWorld.CMS do
  @moduledoc """
  The CMS context.
  """
  @default_article_pagination_limit 10
  @default_article_offset 0

  import Ecto.Query, warn: false
  alias RealWorld.Repo

  alias RealWorld.Account
  alias RealWorld.Account.Following
  alias RealWorld.Account.User
  alias RealWorld.CMS.Article
  alias RealWorld.CMS.Comment
  alias RealWorld.CMS.Favorite
  alias RealWorld.CMS.Tag

  def list_articles(%{} = params \\ %{}) do
    articles =
      cond do
        params[:author] ->
          params[:author]
          |> Account.get_user_by_username()
          |> Ecto.assoc(:articles)

        params[:favorited] ->
          favorited_user = Account.get_user_by_username(params[:favorited])

          Favorite
          |> where(user_id: ^favorited_user.id)
          |> Repo.all()
          |> Ecto.assoc(:article)

        true ->
          Article
      end

    articles
    |> default_articles_list_options
    |> limit(^params[:limit])
    |> offset(^params[:offset])
    |> Repo.all()
  end

  def list_feed(%{user: user} = params \\ %{}) do
    from(a in Article,
      join: f in Following,
      on: a.user_id == f.followee_id,
      where: f.follower_id == ^user.id
    )
    |> default_articles_list_options
    |> limit(^params[:limit])
    |> offset(^params[:offset])
    |> Repo.all()
  end

  defp default_articles_list_options(query) do
    query
    |> join(:inner, [a], u in User, on: a.user_id == u.id)
    |> preload([:user, :favorites])
    |> limit(@default_article_pagination_limit)
    |> offset(@default_article_offset)
    |> order_by(desc: :inserted_at)
  end

  def get_article!(id), do: Repo.get!(Article, id)

  def get_article_by_slug!(slug) do
    Article
    |> where(slug: ^slug)
    |> join(:inner, [a], u in User, on: a.user_id == u.id)
    |> preload(:user)
    |> Repo.one!()
  end

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def favorite_article(%User{} = user, %Article{} = article) do
    %Favorite{}
    |> Favorite.changeset(%{user_id: user.id, article_id: article.id})
    |> Repo.insert()
  end

  def load_favorite(article, nil), do: article

  def load_favorite(article, user) do
    case find_favorite(article, user) do
      %Favorite{} -> Map.put(article, :favorited, true)
      _ -> article
    end
  end

  def load_favorites(articles, nil), do: articles

  def load_favorites(articles, user) do
    articles
    |> Enum.map(fn article -> load_favorite(article, user) end)
  end

  defp find_favorite(%Article{} = article, %User{} = user) do
    query = from(f in Favorite, where: f.article_id == ^article.id and f.user_id == ^user.id)

    Repo.one(query)
  end

  def unfavorite_article(%User{} = user, %Article{} = article) do
    article
    |> find_favorite(user)
    |> Repo.delete()
  end

  def list_comments do
    Repo.all(Comment)
  end

  def list_comments_by_article(%Article{} = article) do
    article
    |> Ecto.assoc(:comments)
    |> join(:inner, [c], u in User, on: c.user_id == u.id)
    |> preload(:user)
    |> Repo.all()
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def list_tags do
    Ecto.Adapters.SQL.query!(Repo, "select count(*) as tag_count, ut.tag
          from articles, lateral unnest(articles.tag_list) as ut(tag)
          group by ut.tag
          order by tag_count desc limit 5;").rows
    |> Enum.map(fn v -> Enum.at(v, 1) end)
  end
end
