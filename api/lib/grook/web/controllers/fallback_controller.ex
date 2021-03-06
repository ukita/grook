defmodule Grook.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Grook.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Grook.Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(Grook.Web.ErrorView, :"404")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> render(Grook.Web.ErrorView, :"403")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(Grook.Web.ErrorView, :"401")
  end
end
