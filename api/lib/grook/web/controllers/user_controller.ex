defmodule Grook.Web.UserController do
  use Grook.Web, :controller

  alias Grook.{Accounts, Relationship}
  alias Grook.Schema.User

  action_fallback Grook.Web.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: Relationship.load_user_rooms_and_subscriptions(user))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: Relationship.load_user_rooms_and_subscriptions(user))
  end
end
