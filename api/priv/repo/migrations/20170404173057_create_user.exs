defmodule Grook.Repo.Migrations.CreateGrook.User do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :active, :boolean, default: true
      add :name, :string, size: 25
      add :username, :string, size: 15
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
