defmodule Grook.Web.RoomControllerTest do
  use Grook.Web.ConnCase

  alias Grook.Chat
  alias Grook.Schema.Room

  @attrs %{topic: "Some room", description: "Lorem Ipsum"}
  @invalid_attrs %{topic: nil, description: nil}
  
  setup do
    user = insert(:user)
    conn = 
      setup_token(user)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, room_path(conn, :index)
    assert json_response(conn, 200)["rooms"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room = insert(:room)
    conn = get conn, room_path(conn, :show, room)

    assert json_response(conn, 200)["room"] == %{
      "id" => room.id,
      "topic" => room.topic,
      "owner_id" => room.owner_id,
      "description" => room.description,
      "members" => [],
      "created_at" => DateTime.to_iso8601(room.inserted_at)}
  end

  test "creates room and renders room when data is valid", %{conn: conn, user: user} do
    conn = post conn, room_path(conn, :create), room: @attrs
    assert %{"id" => id} = json_response(conn, 201)["room"]

    room = Chat.get_room!(id)

    conn = get setup_token(user), room_path(conn, :show, id)
    assert json_response(conn, 200)["room"] == %{
      "id" => room.id,
      "topic" => room.topic,
      "owner_id" => room.owner_id,
      "description" => room.description,
      "members" => [],
      "created_at" => DateTime.to_iso8601(room.inserted_at)}
  end

  test "does not create room and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, room_path(conn, :create), room: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen user room and renders room when data is valid", %{conn: conn, user: user} do
    %Room{id: id} = room = insert(:room, %{owner_id: user.id})
    conn = put conn, room_path(conn, :update, room), room: @attrs

    assert %{"id" => ^id} = json_response(conn, 200)["room"]

    conn = get setup_token(user), room_path(conn, :show, id)
    assert json_response(conn, 200)["room"] == %{
      "id" => room.id,
      "topic" => @attrs.topic,
      "owner_id" => room.owner_id,
      "description" => @attrs.description,
      "members" => [],
      "created_at" => DateTime.to_iso8601(room.inserted_at)}
  end

  test "does not update chosen room and renders errors when data is invalid", %{conn: conn, user: _user} do
    room = insert(:room)
    
    assert_error_sent 404, fn ->
      put conn, room_path(conn, :update, room), room: @invalid_attrs
    end
  end

  test "does not update chosen room and renders errors when user is not the owner", %{conn: conn, user: user} do
    room = insert(:room, %{owner_id: user.id})
    conn = put conn, room_path(conn, :update, room), room: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen room", %{conn: conn, user: user} do
    room = insert(:room, %{owner_id: user.id})
    conn = delete conn, room_path(conn, :delete, room)

    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get setup_token(user), room_path(conn, :show, room)
    end
  end

  test "does not delete chosen room when user is not the owner", %{conn: conn, user: user} do
    room = insert(:room)

    assert_error_sent 404, fn -> 
      delete conn, room_path(conn, :delete, room)
    end
    
    conn = get setup_token(user), room_path(conn, :show, room)
    assert json_response(conn, 200)
  end
end
