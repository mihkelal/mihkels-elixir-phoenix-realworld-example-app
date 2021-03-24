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

  def list_articles(%{} = params \\ %{}) do
    case params[:author] && Account.get_user_by_username(params[:author]) do
      %User{} = user -> Ecto.assoc(user, :articles)
      nil -> Article
    end
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
    |> preload(:user)
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

  def list_comments do
    Repo.all(Comment)
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
end
