defmodule Grook.Repo.Migrations.CreateRoomsMembers do
  use Ecto.Migration

  def change do
    create table(:rooms_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :admin, :boolean, null: false, default: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :room_id, references(:rooms, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:rooms_members, [:user_id, :room_id], name: :members_user_room_index)
  end
end
