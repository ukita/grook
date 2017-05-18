defmodule Grook.Web.RoomController do
  use Grook.Web, :controller

  alias Grook.Chat
  alias Grook.Schema.Room

  action_fallback Grook.Web.FallbackController

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, params, user) do
    IO.inspect(params)
    rooms = 
      case params do
        %{"topic" => topic} -> Chat.search_rooms_by_topic(topic)
        _                   -> Chat.list_rooms_by_member(user)
      end

    render(conn, "index.json", rooms: rooms)
  end
  
  def create(conn, %{"room" => room_params}, user) do
    with {:ok, %Room{} = room} <- Chat.create_room(user, room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    room = Chat.get_room!(id)
    render(conn, "show.json", room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}, user) do
    room = Chat.get_user_room!(user, id)
    with {:ok, %Room{} = room} <- Chat.update_room(room, room_params) do
      render(conn, "show.json", room: room)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    room = Chat.get_user_room!(user, id)
    with {:ok, %Room{}} <- Chat.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
