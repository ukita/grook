defmodule Grook.Repo.Migrations.CreatePostsFiles do
  use Ecto.Migration

  def change do
    create table(:posts_attachments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:posts, type: :binary_id, on_delete: :delete_all)
      add :file, :string

      timestamps()
    end

    create index(:posts_attachments, [:post_id])
  end
end
