defmodule RealWorld.Account.Following do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.Account.User

  @required_fields ~w(follower_id followee_id)a

  schema "followings" do
    belongs_to :follower, User
    belongs_to :followee, User

    timestamps()
  end

  @doc false
  def changeset(following, attrs) do
    following
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:follower)
    |> assoc_constraint(:followee)
    |> unique_constraint([:follower_id, :followee_id])
  end
end
