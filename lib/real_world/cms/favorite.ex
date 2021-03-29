defmodule RealWorld.CMS.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.Account.User
  alias RealWorld.CMS.Article

  @required_fields ~w(user_id article_id)a

  schema "favorites" do
    belongs_to :user, User
    belongs_to :article, Article

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:article)
    |> unique_constraint([:user_id, :article_id])
  end
end
