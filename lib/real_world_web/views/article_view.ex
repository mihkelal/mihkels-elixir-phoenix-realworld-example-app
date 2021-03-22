defmodule RealWorldWeb.ArticleView do
  use RealWorldWeb, :view
  alias RealWorldWeb.ArticleView
  alias RealWorldWeb.ProfileView

  def render("index.json", %{articles: articles}) do
    %{
      articles: render_many(articles, ArticleView, "article.json"),
      articlesCount: length(articles)
    }
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tagList: [],
      createdAt: article.inserted_at,
      updatedAt: article.updated_at,
      favorited: false,
      favoritesCount: article.favorites_count,
      author: render_one(article.user, ProfileView, "profile.json", as: :user, following: false)
    }
  end
end
