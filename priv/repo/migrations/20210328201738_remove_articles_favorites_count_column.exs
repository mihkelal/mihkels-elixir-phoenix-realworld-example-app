defmodule RealWorld.Repo.Migrations.RemoveArticlesFavoritesCountColumn do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      remove :favorites_count, :integer, default: 0, null: false
    end
  end
end
