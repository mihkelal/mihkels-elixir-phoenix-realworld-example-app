defmodule RealWorld.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :slug, :string, null: false
      add :title, :string, null: false
      add :description, :string, null: false
      add :body, :text, null: false
      add :favorites_count, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:articles, [:slug])
    create unique_index(:articles, [:title])
    create index(:articles, [:user_id])
  end
end
