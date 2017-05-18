defmodule Grook.Schema.Room do
  use Grook.Schema

  schema "rooms" do
    field :active, :boolean, default: true
    field :description, :string
    field :topic, :string
    
    belongs_to :owner, Grook.Schema.User, foreign_key: :owner_id
    many_to_many :members, Grook.Schema.User, join_through: Grook.Schema.RoomMember
    has_many :posts, Grook.Schema.Post

    timestamps()
  end
end
