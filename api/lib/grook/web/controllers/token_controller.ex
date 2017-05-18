defmodule Grook.Web.TokenController  do
  use Grook.Web, :controller

  alias Grook.Accounts

  action_fallback Grook.Web.FallbackController

  def create(conn, %{"user" => %{"username" => username, "password" => password}}), do: create_token(conn, username, password)
  def create(conn, %{"user" => %{"email"    => email,    "password" => password}}), do: create_token(conn, email, password)

  defp create_token(conn, username, password) do
    with {:ok, user} <- Accounts.login_user_by_credentials(username, password) do
      new_conn      = Guardian.Plug.api_sign_in(conn, user)
      jwt           = Guardian.Plug.current_token(new_conn)
      {:ok, claims} = Guardian.Plug.claims(new_conn)
      exp           = Map.get(claims, "exp")

      new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", to_string(exp))
      |> put_status(:created)
      |> render(Grook.Web.SessionView, "create.json", jwt: jwt, exp: exp, user: user)
    end
  end
end
