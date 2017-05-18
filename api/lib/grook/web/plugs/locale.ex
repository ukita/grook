defmodule Grook.Web.Plug.Locale do
  import Plug.Conn

  def init(_opts), do: nil

  def call(conn, _opts) do
    case get_req_header(conn, "locale") do
      []          -> conn
      [""| _]     -> conn
      [locale|_]  ->
        Gettext.put_locale(Grook.Web.Gettext, locale)
        put_resp_header(conn, "locale", locale)
    end
  end
end
