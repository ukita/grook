defmodule Grook.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :post_id, references(:posts, type: :binary_id, on_delete: :delete_all)
      add :emoji_name, :string, size: 20

      timestamps()
    end

    create index(:reactions, [:user_id])
    create index(:reactions, [:post_id])
  end
end
