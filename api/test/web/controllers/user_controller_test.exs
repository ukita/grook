defmodule Grook.Web.UserControllerTest do
  use Grook.Web.ConnCase, async: true

  alias Grook.Accounts

  @create_attrs %{email: "johndoe@example.com", name: "John Doe", username: "johndoe", password: "weakpass", password_confirmation: "weakpass"}
  @invalid_attrs %{email: nil, name: nil, username: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert %{"id" => _id} = json_response(conn, 201)["user"]
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
