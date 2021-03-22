defmodule RealWorld.CMS.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealWorld.Account.User

  @required_fields ~w(slug title description body favorites_count)a

  schema "articles" do
    field :body, :string
    field :description, :string
    field :favorites_count, :integer
    field :slug, :string
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> unique_constraint(:slug)
    |> unique_constraint(:title)
  end
end
