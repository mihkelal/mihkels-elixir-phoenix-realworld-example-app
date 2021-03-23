defmodule RealWorld.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.CMS.Article

  @required_fields ~w(email username password)a
  @optional_fields ~w(bio image)a

  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :string
    field :password, :string
    field :username, :string
    has_many :articles, Article

    many_to_many :followees, __MODULE__,
      join_through: RealWorld.Account.Following,
      join_keys: [follower_id: :id, followee_id: :id]

    many_to_many :followers, __MODULE__,
      join_through: RealWorld.Account.Following,
      join_keys: [followee_id: :id, follower_id: :id]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> add_password_hash
  end

  def add_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.change(changeset, Argon2.add_hash(password, hash_key: :password))
  end

  def add_password_hash(changeset) do
    changeset
  end
end
