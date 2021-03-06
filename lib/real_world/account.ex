defmodule RealWorld.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias RealWorld.Repo

  alias RealWorld.Account.{Following, User}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_username(username), do: Repo.get_by(User, username: username)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def find_user_and_check_password(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "User not found"}
      user -> Argon2.check_pass(user, password, hash_key: :password)
    end
  end

  def encode_and_sign_user_id(user) do
    case RealWorldWeb.Guardian.encode_and_sign(user, %{}, token_type: :access) do
      {:ok, jwt, _} -> {:ok, jwt}
      {:error, message} -> {:error, message}
    end
  end

  def create_following(%User{} = follower, %User{} = followee) do
    %Following{}
    |> Following.changeset(%{follower_id: follower.id, followee_id: followee.id})
    |> Repo.insert()
  end

  def delete_following(%User{} = follower, %User{} = followee) do
    Following
    |> Repo.get_by!(follower_id: follower.id, followee_id: followee.id)
    |> Repo.delete()
  end

  def following_exists?(%User{} = follower, %User{} = followee) do
    Following
    |> from
    |> where(follower_id: ^follower.id, followee_id: ^followee.id)
    |> Repo.exists?()
  end
end
