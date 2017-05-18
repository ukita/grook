defmodule Grook.Schema.User do
  use Grook.Schema

  schema "users" do
    field :active, :boolean, default: true
    field :name, :string
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :rooms, Grook.Schema.Room, foreign_key: :owner_id
    many_to_many :subscriptions, Grook.Schema.Room, join_through: Grook.Schema.RoomMember
    has_many :posts, Grook.Schema.Post

    timestamps()
  end
end
