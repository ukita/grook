defmodule Grook.Web.AccountControllerTest do
  use Grook.Web.ConnCase, async: true
  alias Grook.Web.UserView
  alias Grook.Relationship

  @attrs %{email: "joanadoe@example.com", name: "Joana Doe", username: "joanadoe", password: "weakpass", password_confirmation: "weakpass"}
  @invalid_attrs %{email: nil, name: nil, username: nil, password: nil}

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  test "refuse unauthenticated user", %{conn: conn} do
    conn = get conn, account_path(conn, :show)
    assert json_response(conn, 401)

    conn = put conn, account_path(conn, :update)
    assert json_response(conn, 401)

    conn = delete conn, account_path(conn, :delete)
    assert json_response(conn, 401)
  end

  test "updates chosen user and renders user when data is valid", %{conn: conn, user: user} do
    user = Relationship.load_user_rooms_and_subscriptions(user)

    conn = put setup_token(user), account_path(conn, :update), user: @attrs
    assert json_response(conn, 200)

    conn = get setup_token(user), account_path(conn, :show)
    assert json_response(conn, 200) == render_json(UserView, "show.json", user: Map.merge(user, @attrs))
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = put setup_token(user), account_path(conn, :update), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen user", %{conn: conn, user: user} do
    conn = delete setup_token(user), account_path(conn, :delete)
    assert response(conn, 204)

    conn = get setup_token(user), account_path(conn, :show)
    assert response(conn, 403)
  end
end
