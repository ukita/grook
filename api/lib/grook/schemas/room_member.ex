defmodule Grook.Schema.RoomMember do
  use Grook.Schema

  schema "rooms_members" do
    field :admin, :boolean, default: false
    belongs_to :user, Grook.Schema.User
    belongs_to :room, Grook.Schema.Room

    timestamps()
  end
end
