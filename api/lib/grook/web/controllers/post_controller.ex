defmodule Grook.Web.PostController do
  use Grook.Web, :controller
  
  alias Grook.{Chat, Relationship}

  action_fallback Grook.Web.FallbackController

  def action(conn, _) do
    room = Chat.get_room!(conn.params["room_id"])

    apply(__MODULE__, action_name(conn),
      [conn, conn.params, room, Guardian.Plug.current_resource(conn)])
  end

  def index(conn, _params, room, _user) do
    posts =
      Chat.list_posts(room)
      |>Relationship.load_posts_attachments

    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}, room, user) do
    with {:ok, post} <- Chat.create_post(room, user, post_params) do
      post_with_attachments = Relationship.load_post_attachments(post)
      broadcast_post(room, post_with_attachments)
      
      conn
      |> put_status(:created)
      |> render("show.json", post: post_with_attachments)
    end
  end

  defp broadcast_post(room, post) do
    Grook.Web.Endpoint.broadcast("room:#{room.id}", "post_created", %{post: Phoenix.View.render_one(post, Grook.Web.PostView, "post.json")})
  end
end
