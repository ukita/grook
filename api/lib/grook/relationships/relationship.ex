defmodule Grook.Relationship do
  import Ecto, only: [assoc: 2]
  import Ecto.{Query, Changeset}, warn: false
  alias Grook.Repo

  def load_user_rooms(user), do: Repo.preload(user, :rooms)

  def load_user_subscriptions(user), do: Repo.preload(user, :subscriptions)

  def load_user_rooms_and_subscriptions(user) do
    user
    |> load_user_rooms
    |> load_user_subscriptions
  end

  def load_post_attachments(post), do: Repo.preload(post, :attachments)

  def load_posts_attachments(posts) do
    Enum.map(posts, fn(post) ->
      load_post_attachments(post)
    end)
  end

  def get_user_subscriptions(user), do: Repo.all(assoc(user, :subscriptions))

  def get_room_members(room), do: Repo.all(assoc(room, :members))
end
