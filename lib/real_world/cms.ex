defmodule RealWorld.CMS do
  @moduledoc """
  The CMS context.
  """
  @default_article_pagination_limit 10
  @default_article_offset 0

  import Ecto.Query, warn: false
  alias RealWorld.Repo

  alias RealWorld.Account.User
  alias RealWorld.CMS.Article

  def list_articles do
    Repo.all(Article)
  end

  def list_user_articles(%User{} = user, limit: limit, offset: offset) do
    limit = limit || @default_article_pagination_limit
    offset = offset || @default_article_offset

    Ecto.assoc(user, :articles)
    |> join(:inner, [a], u in User, on: a.user_id == u.id)
    |> preload(:user)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end

  def get_article!(id), do: Repo.get!(Article, id)

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
end
