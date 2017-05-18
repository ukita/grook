defmodule Grook.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id)
      add :room_id, references(:rooms, type: :binary_id, on_delete: :delete_all)
      add :message, :text

      timestamps()
    end

    create index(:posts, [:user_id])
    create index(:posts, [:room_id])
  end
end
