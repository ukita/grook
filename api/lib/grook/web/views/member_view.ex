defmodule Grook.Web.MemberView do
  use Grook.Web, :view
  alias Grook.Web.UserView
  
  def render("index.json", %{members: members}) do
    %{members: render_many(members, UserView, "user.json")}
  end
end
