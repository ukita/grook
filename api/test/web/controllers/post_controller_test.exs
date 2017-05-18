defmodule Grook.Web.PostControllerTest do
  use Grook.Web.ConnCase

  @attrs %{message: "Some message"}
  @invalid_attrs %{message: nil}
  
  setup do
    user = insert(:user)
    room = insert(:room)
    conn = 
      setup_token(user)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, room: room, user: user}
  end

  test "lists all entries on index", %{conn: conn, room: room} do
    conn = get conn, room_post_path(conn, :index, room)
    assert json_response(conn, 200)["posts"] == []
  end

  test "creates post and renders post when data is valid", %{conn: conn, room: room} do
    conn = post conn, room_post_path(conn, :create, room), post: @attrs
    assert json_response(conn, 201)["post"]
  end

  test "does not create post and renders errors when data is invalid", %{conn: conn, room: room} do
    conn = post conn, room_post_path(conn, :create, room), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
