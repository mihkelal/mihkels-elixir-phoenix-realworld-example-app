defmodule RealWorld.CMS.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.Account.User
  alias RealWorld.CMS.Article

  @required_fields ~w(body)a

  schema "comments" do
    field :body, :string
    belongs_to :user, User
    belongs_to :article, Article

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:article)
  end
end
