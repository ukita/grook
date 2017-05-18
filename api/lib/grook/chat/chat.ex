defmodule Grook.Chat do
  @moduledoc """
  The boundary for the Chat system.
  """

  import Ecto.{Query, Changeset}, warn: false
  use Arc.Ecto.Schema

  alias Grook.Repo

  alias Grook.Schema.{User, Room, Post, RoomMember, PostAttachment, Reaction}

  def list_rooms() do
    Repo.all(Room)
  end

  def search_rooms_by_topic(topic) do
    query = 
      from r in Room,
      preload: [:members],
      where: ilike(r.topic, ^("%#{topic}%"))

    Repo.all(query)
  end

  def list_rooms_by_member(%User{id: user_id}) do
    query = 
      from r in Room,
        preload: [:members],
        join: m in RoomMember, on: m.room_id == r.id,
        where: m.user_id == ^user_id
    Repo.all(query)
  end

  def get_room!(room_id), do: Repo.get!(Room, room_id)

  def get_user_room!(%User{id: owner_id}, room_id) do
    Room
    |> where(id: ^room_id)
    |> where(owner_id: ^owner_id)
    |> Repo.one!()
  end

  def create_room(%User{} = user, attrs \\ %{}) do
    changeset = 
      %Room{}
      |> room_changeset(attrs)
      |> put_assoc(:owner, user)
    
    with {:ok, room}    <- Repo.insert(changeset),
         {:ok, _member} <- create_room_member(room, user, admin: true),
    do: {:ok, room}
  end

  def update_room(room, attrs) do
    room
    |> room_changeset(attrs)
    |> Repo.update()
  end

  def delete_room(room), do: Repo.delete(room)

  defp room_changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:owner_id, :topic, :description])
    |> validate_required([:topic])
    |> validate_length(:topic, max: 50)
    |> assoc_constraint(:owner)
  end

  def list_room_members(%Room{id: room_id}) do
    query = 
      from u in User,
        join: m in RoomMember, on: m.user_id == u.id,
        where: m.room_id == ^room_id

    Repo.all(query)
  end

  def create_room_member(%Room{id: room_id}, %User{id: user_id}, opts \\ [admin: false]) do
    %RoomMember{}
    |> member_changeset(%{room_id: room_id, user_id: user_id, admin: opts[:admin]})
    |> Repo.insert()
  end

  def get_room_member!(%Room{id: room_id}, %User{id: user_id}) do
    query = 
      from m in RoomMember,
      where: m.room_id == ^room_id and m.user_id == ^user_id
    
    Repo.one!(query)
  end

  def delete_room_member(room_member), do: Repo.delete(room_member)

  defp member_changeset(%RoomMember{} = room_member, attrs) do
    room_member
    |> cast(attrs, [:room_id, :user_id, :admin])
    |> validate_required([:room_id, :user_id])
    |> assoc_constraint(:room)
    |> assoc_constraint(:user)
    |> unique_constraint(:user, name: :members_user_room_index)
  end

  def get_post!(post_id), do: Repo.get!(Post, post_id)

  def list_posts(%Room{id: room_id}) do
    Repo.all(all_posts(room_id))
  end

  def list_recent_posts(%Room{id: room_id}, unix_timestamp), do: list_recent_posts(room_id, unix_timestamp)
  def list_recent_posts(room_id, unix_timestamp) do
    query = 
      from p in all_posts(room_id),
        where: p.inserted_at > ^Timex.from_unix(unix_timestamp)

    Repo.all(query)
  end

  def create_post(%Room{} = room, %User{} = user, attrs) do
    %Post{}
    |> post_changeset(attrs)
    |> put_assoc(:room, Map.put(room, :updated_at, Timex.now()))
    |> put_assoc(:user, user)
    |> put_assoc(:attachments, list_attachments(attrs["attachments"]))
    |> Repo.insert()
  end

  defp post_changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:message])
    |> validate_required([:message])
    |> assoc_constraint(:room)
    |> assoc_constraint(:user)
  end

  defp all_posts(room_id) do
    from p in Post,
      preload: [:user, :attachments],
      where: p.room_id == ^room_id,
      order_by: [asc: p.inserted_at]
  end

  def list_attachments(nil), do: []
  def list_attachments([]),  do: []
  def list_attachments(attachment_ids) when is_list(attachment_ids) do
    query = 
      from a in PostAttachment,
        where: a.id in ^attachment_ids

    Repo.all(query)
  end

  def create_attachment(attrs \\ %{}) do
    %PostAttachment{}
    |> Map.put(:id, Ecto.UUID.generate)
    |> attachment_changeset(attrs)
    |> Repo.insert()
  end

  def attachment_changeset(%PostAttachment{} = attachment, attrs) do
    attachment
    |> cast(attrs, [:id])
    |> cast_attachments(attrs, [:file])
    |> validate_required([:id, :file])
  end

  def get_reaction!(reaction_id), do: Repo.get!(Reaction, reaction_id)

  def get_user_reaction!(%User{id: user_id}, reaction_id) do
    query = 
      from r in Reaction,
      where: r.id == ^reaction_id and r.user_id == ^user_id

    Repo.one!(query)
  end

  def add_post_reaction(post, user, attrs) do
    %Reaction{}
    |> reaction_changeset(attrs)
    |> put_assoc(:user, user)
    |> put_assoc(:post, post)
    |> Repo.insert
  end

  def delete_reaction(reaction), do: Repo.delete(reaction)

  def reaction_changeset(%Reaction{} = reaction, attrs) do
    reaction
    |> cast(attrs, [:emoji_name])
    |> validate_required([:emoji_name])
  end
end
