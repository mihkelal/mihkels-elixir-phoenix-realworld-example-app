defmodule RealWorldWeb.ProfileView do
  use RealWorldWeb, :view
  alias RealWorldWeb.ProfileView

  def render("show.json", %{user: user}) do
    %{profile: render_one(user, ProfileView, "profile.json", as: :user)}
  end

  def render("profile.json", %{user: user}) do
    %{
      username: user.username,
      bio: user.bio,
      image: user.image,
      following: false
    }
  end
end
