defmodule RealWorld.Repo.Migrations.CreateFollowings do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add :follower_id, references(:users), null: false
      add :followee_id, references(:users), null: false

      timestamps()
    end

    create index(:followings, :follower_id)
    create index(:followings, :followee_id)
    create unique_index(:followings, [:follower_id, :followee_id])
  end
end
