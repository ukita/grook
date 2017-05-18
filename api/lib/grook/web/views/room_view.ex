defmodule Grook.Web.RoomView do
  use Grook.Web, :view
  alias Grook.Web.RoomView
  alias Grook.Web.UserView

  def render("index.json", %{rooms: rooms}) do
    %{rooms: render_many(rooms, RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{room: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{id: room.id,
      owner_id: room.owner_id,
      topic: room.topic,
      members: render_members(room),
      description: room.description,
      created_at: room.inserted_at
    }
  end

  defp render_members(room) do
    case Ecto.assoc_loaded?(room.members) do
      true -> render_many(room.members, UserView, "user.json")
      _    -> []
    end
  end
end
