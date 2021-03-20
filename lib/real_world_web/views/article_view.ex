defmodule RealWorldWeb.ArticleView do
  use RealWorldWeb, :view
  alias RealWorldWeb.ArticleView

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
      id: article.id,
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      favorites_count: article.favorites_count
    }
  end
end
