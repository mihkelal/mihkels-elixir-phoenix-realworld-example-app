defmodule RealWorldWeb.ProfileView do
  use RealWorldWeb, :view
  alias RealWorldWeb.ProfileView

  def render("show.json", %{user: user, following: following}) do
    %{profile: render_one(user, ProfileView, "profile.json", as: :user, following: following)}
  end

  def render("profile.json", %{user: user, following: following}) do
    %{
      username: user.username,
      bio: user.bio,
      image: user.image,
      following: following
    }
  end

  def render("error.json", %{message: message}) do
    %{errors: %{message: [message]}}
  end
end
