defmodule Grook.Web.UserView do
  use Grook.Web, :view
  alias Grook.Web.{UserView, RoomView}

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      usermame: user.username,
      email: user.email,
      created_at: user.inserted_at,
      updated_at: user.updated_at}
  end
end
