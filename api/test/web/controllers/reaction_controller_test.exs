defmodule Grook.Web.ReactionControllerTest do
  use Grook.Web.ConnCase

  @attrs %{emoji_name: ":smile:"}
  @invalid_attrs %{emoji_name: nil}
  
  setup do
    post = insert(:post)
    user = insert(:user)
    conn = 
      setup_token(user)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, post: post, user: user}
  end

  test "creates post reactions and renders post when data is valid", %{conn: conn, post: post} do
    conn = post conn, room_post_reaction_path(conn, :create, post.room_id, post.id), reaction: @attrs
    assert json_response(conn, 201)
  end

  test "does not create reactions and renders errors when data is invalid", %{conn: conn, post: post} do
    conn = post conn, room_post_reaction_path(conn, :create, post.room_id, post.id), reaction: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes reaction", %{conn: conn, post: post, user: user} do
    reaction = insert(:reaction, %{post_id: post.id, user_id: user.id})
    conn = delete conn, room_post_reaction_path(conn, :delete, post.room_id, post.id, reaction)
    assert response(conn, 204)
  end
end
