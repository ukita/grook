defmodule Grook.Web.SessionView do
  use Grook.Web, :view

  def render("create.json", %{jwt: jwt, exp: exp, user: user}) do
    %{user: render_user(user), token: %{jwt: jwt, exp: exp}}
  end

  defp render_user(user) do
    %{id: user.id,
      name: user.name,
      usermame: user.username,
      email: user.email,
      created_at: user.inserted_at,
      updated_at: user.updated_at}
  end
end
