defmodule Grook.Guardian.ErrorHandler do
import Plug.Conn

  def unauthenticated(conn, _params) do
    respond(conn, :json, 401, "Unauthenticated")
  end

  def unauthorized(conn, _params) do
    respond(conn, :json, 403, "Unauthorized")
  end

  def no_resource(conn, _params) do
    respond(conn, :json, 403, "Unauthorized")
  end

  defp respond(conn, :json, status, msg) do
    try do
      conn
      |> configure_session(drop: true)
      |> put_resp_content_type("application/json")
      |> send_resp(status, encode_message(msg))
    rescue ArgumentError ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, encode_message(msg))
    end
  end

  defp encode_message(message) do
    Poison.encode!(%{errors: %{detail: [message]}})
  end
end
