defmodule Grook.Web.ReactionController do
  use Grook.Web, :controller

  alias Grook.Chat
  alias Grook.Schema.Reaction

  action_fallback Grook.Web.FallbackController

  def action(conn, _) do
    post = Chat.get_post!(conn.params["post_id"])

    apply(__MODULE__, action_name(conn),
      [conn, conn.params, post, Guardian.Plug.current_resource(conn)])
  end

  def create(conn, %{"reaction" => reaction_params}, post, user) do
    with {:ok, reaction} <- Chat.add_post_reaction(post, user, reaction_params) do
      conn
      |> put_status(:created)
      |> render("show.json", reaction: reaction)
    end
  end

  def delete(conn, %{"id" => reaction_id}, _post, user) do
    reaction = Chat.get_user_reaction!(user, reaction_id)
    with {:ok, %Reaction{}} <- Chat.delete_reaction(reaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
