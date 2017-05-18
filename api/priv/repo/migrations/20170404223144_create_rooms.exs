defmodule Grook.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :active, :boolean, default: true, null: false
      add :topic, :string, size: 50
      add :description, :text, null: true
      add :owner_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:rooms, [:owner_id])
  end
end
