defmodule Grook.Web.MemberController do
  use Grook.Web, :controller

  alias Grook.Chat
  alias Grook.Schema.RoomMember

  action_fallback Grook.Web.FallbackController

  def action(conn, _) do
    room = Chat.get_room!(conn.params["room_id"])

    apply(__MODULE__, action_name(conn),
      [conn, conn.params, room, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, _params, room, _user) do
    members = Chat.list_room_members(room)
    render(conn, "index.json", members: members)
  end

  def create(conn, _params, room, user) do
    with {:ok, %RoomMember{} = _member} <- Chat.create_room_member(room, user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", room_path(conn, :show, room))
      |> render(Grook.Web.RoomView, "show.json", room: room)
    end
  end

  def delete(conn, _params, room, user) do
    member = Chat.get_room_member!(room, user)
    with {:ok, %RoomMember{}} <- Chat.delete_room_member(member) do
      send_resp(conn, :no_content, "")
    end
  end
end
