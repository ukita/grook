defmodule Grook.Web.AccountController do
  use Grook.Web, :controller

  alias Grook.{Accounts, Relationship}
  alias Grook.Schema.User
  alias Grook.Web.UserView

  action_fallback Grook.Web.FallbackController

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, Guardian.Plug.current_resource(conn)])
  end

  def show(conn, _params, user) do
    render(conn, UserView, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params}, user) do
    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, UserView, "show.json", user: Relationship.load_user_rooms_and_subscriptions(user))
    end
  end

  def delete(conn, _params, user) do
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
