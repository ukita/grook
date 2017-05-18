defmodule Grook.Web.RoomChannel do
  use Grook.Web, :channel

  alias Grook.Chat
  alias Grook.Web.PostView
  alias Guardian.Phoenix.Socket

  def join("room:" <> room_id, payload, socket) do
    last_seen_post = payload["last_seen_post"] || 0
    posts = Chat.list_recent_posts(room_id, last_seen_post)
    response = %{
      posts: Phoenix.View.render_many(posts, PostView, "post.json")
    }

    Chat.create_room_member(
      Chat.get_room!(room_id), 
      Socket.current_resource(socket)
    )

    {:ok, response, assign(socket, :room_id, room_id)}
  end

  def handle_in(event, payload, socket) do
    user = Socket.current_resource(socket)
    room = Chat.get_room!(socket.assigns.room_id)
    handle_in(event, payload, user, room, socket)
  end

  def handle_in("new_post", %{"post" => post_params} = payload, user, room, socket) do
    case Chat.create_post(room, user, post_params) do
      {:ok, post} -> 
        broadcast_post(socket, post)
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, :error, socket}
    end
  end

  defp broadcast_post(socket, post) do
    post = Grook.Repo.preload(post, [:user, :attachments])
    rendered_post = Phoenix.View.render_one(post, PostView, "post.json")
    broadcast!(socket, "post_created", %{post: rendered_post})
  end

end
