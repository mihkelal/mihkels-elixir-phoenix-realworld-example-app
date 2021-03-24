defmodule RealWorld.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :article_id, references(:articles, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:article_id])
  end
end
