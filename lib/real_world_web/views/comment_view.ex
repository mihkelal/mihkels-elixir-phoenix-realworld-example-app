defmodule RealWorldWeb.CommentView do
  use RealWorldWeb, :view
  alias RealWorldWeb.CommentView
  alias RealWorldWeb.ProfileView

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      createdAt: comment.inserted_at,
      updatedAt: comment.updated_at,
      author: render_one(comment.user, ProfileView, "profile.json", as: :user, following: false)
    }
  end
end
