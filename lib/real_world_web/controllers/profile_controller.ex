defmodule RealWorldWeb.ProfileController do
  use RealWorldWeb, :controller

  alias RealWorld.Account
  alias RealWorld.Account.User

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:follow, :unfollow]

  def show(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user ->
        current_user = conn.assigns.current_user

        render(conn, "show.json", user: user, following: Account.following_exists?(current_user, user))

      nil ->
        send_resp(conn, 404, "")
    end
  end

  def follow(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user ->
        current_user = conn.assigns.current_user

        case Account.create_following(current_user, user) do
          {:ok, _following} ->
            render(conn, "show.json", user: user, following: true)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", message: inspect(changeset.errors))
        end

      nil ->
        send_resp(conn, 404, "")
    end
  end

  def unfollow(conn, %{"username" => username}) do
    case RealWorld.Account.get_user_by_username(username) do
      %User{} = user ->
        current_user = conn.assigns.current_user

        case Account.delete_following(current_user, user) do
          {:ok, _following} ->
            render(conn, "show.json", user: user, following: false)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", message: inspect(changeset.errors))
        end

      nil ->
        send_resp(conn, 404, "")
    end
  end
end
