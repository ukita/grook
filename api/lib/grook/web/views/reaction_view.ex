defmodule Grook.Web.ReactionView do
  use Grook.Web, :view
  alias Grook.Web.ReactionView

  def render("show.json", %{reaction: reaction}) do
    %{reaction: render_one(reaction, ReactionView, "reaction.json")}
  end

  def render("reaction.json", %{reaction: reaction}) do
    %{id: reaction.id,
      post_id: reaction.post_id,
      created_at: reaction.inserted_at}
  end
end
