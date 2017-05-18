defmodule Grook.Web.TokenControllerTest do
  use Grook.Web.ConnCase, async: true

  setup %{conn: conn} do
    user = build(:user) |> set_password("secret123") |> insert()
    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  test "creates token using username and renders token when credentials is valid", %{conn: conn, user: user} do
    conn = post conn, token_path(conn, :create), %{"user" => %{"username" => user.username, "password" => "secret123"}}

    assert %{"token" => %{"jwt" => jwt}} = json_response(conn, 201)
    assert user.id == get_user_from_token(jwt).id
  end

  test "creates token using email and renders token when credentials is valid", %{conn: conn, user: user} do
    conn = post conn, token_path(conn, :create), %{"user" => %{"email" => user.email, "password" => "secret123"}}

    assert %{"token" => %{"jwt" => jwt}} = json_response(conn, 201)
    assert user.id == get_user_from_token(jwt).id
  end

  test "does not create token and renders errors when username is invalid", %{conn: conn} do
    conn = post conn, token_path(conn, :create), %{"user" => %{"username" => "wrongusername", "password" => "wrongpass"}}
    assert %{"detail" => "Unauthorized"} = json_response(conn, 403)["errors"]
  end

  test "does not create token and renders errors when password is invalid", %{conn: conn, user: user} do
    conn = post conn, token_path(conn, :create), %{"user" => %{"username" => user.username, "password" => "wrongpass"}}
    assert %{"detail" => "Unauthenticated"} = json_response(conn, 401)["errors"]
  end

  defp get_user_from_token(jwt) do
    %{"aud" => aud} = Guardian.decode_and_verify!(jwt)
    {:ok, user} = Grook.Guardian.Serializer.from_token(aud)
    user
  end
end
