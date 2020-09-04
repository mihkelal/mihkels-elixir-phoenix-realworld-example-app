defmodule RealWorldWeb.UserView do
  use RealWorldWeb, :view
  alias RealWorldWeb.UserView

  def render("show.json", %{jwt: jwt, user: user}) do
    %{user: Map.put(render_one(user, UserView, "user.json"), :token, jwt)}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("login.json", %{user: user, jwt: jwt}) do
    %{user: Map.put(render_one(user, UserView, "user.json"), :token, jwt)}
  end

  def render("error.json", %{message: message}) do
    %{errors: %{message: [message]}}
  end

  def render("user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: user.image
    }
  end
end
