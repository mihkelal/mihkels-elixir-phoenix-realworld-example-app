defmodule RealWorld.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :article_id, references(:articles, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:favorites, [:user_id])
    create index(:favorites, [:article_id])
    create unique_index(:favorites, [:user_id, :article_id])
  end
end
