defmodule Grook.Web.MemberControllerTest do
  use Grook.Web.ConnCase

  setup do
    user = insert(:user)
    room = insert(:room)
    conn = 
      setup_token(user)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, room: room, user: user}
  end

  test "lists all members on index", %{conn: conn, room: room} do
    conn = get conn, room_member_path(conn, :index, room)
    assert json_response(conn, 200)["members"] == []
  end

  test "creates member and renders post when data is valid", %{conn: conn, room: room} do
    conn = post conn, room_member_path(conn, :create, room)
    assert json_response(conn, 201)["room"]
  end

  test "does not create member and renders errors when data is invalid", %{conn: conn, room: room, user: user} do
    Grook.Repo.delete!(user)
    conn = post conn, room_member_path(conn, :create, room)
    assert json_response(conn, 403)["errors"] != %{}
  end

  test "deletes member", %{conn: conn, room: room, user: user} do
    insert(:member, %{room_id: room.id, user_id: user.id})
    conn = delete conn, room_member_path(conn, :delete, room)
    assert response(conn, 204)
  end
end
