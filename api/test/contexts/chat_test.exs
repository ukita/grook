defmodule Grook.Contexts.ChatTest do
  use Grook.DataCase

  alias Grook.Chat
  alias Grook.Schema.{Room, User, Post, RoomMember}

  @room_attrs %{topic: "Whispers", description: "Shhhhhhhh!!!"}
  @invalid_room_attrs %{topic: nil, description: nil}

  @post_attrs %{message: "Message 1"}
  @invalid_post_attrs %{message: nil}
  
  test "list_rooms/1 returns all rooms" do
    room = insert(:room)
    assert Chat.list_rooms() == [room]
  end

  test "get_room!/1 returns the room with given id" do
    room = insert(:room)
    assert Chat.get_room!(room.id) == room
  end

  test "get_user_room!/2 returns the user room with given id" do
    user = insert(:user)
    room = insert(:room, %{owner_id: user.id})

    assert Chat.get_user_room!(user, room.id) == room
  end

  test "create_room/2 with valid data creates a room" do
    user = insert(:user)
    {:ok, %Room{} = room} = Chat.create_room(user, @room_attrs)
    
    assert room.active
    assert room.topic == @room_attrs.topic
    assert room.description == @room_attrs.description
  end

  test "create_room/2 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Chat.create_room(%User{}, @invalid_room_attrs)
  end

  test "update_room/2 with valid data updates a room" do
    room = insert(:room)
    assert {:ok, %Room{} = room} = Chat.update_room(room, @room_attrs)

    assert room.topic == @room_attrs.topic
    assert room.description == @room_attrs.description
  end

  test "update_room/2 with invalid data returns error changeset" do
    room = insert(:room)
    assert {:error, %Ecto.Changeset{}} = Chat.update_room(room, @invalid_room_attrs)
  end

  test "create_room_member/2 with valid data creates a room member" do
    room = insert(:room)
    user = insert(:user)
    assert {:ok, %RoomMember{} = member} = Chat.create_room_member(room, user)
    assert member.room_id == room.id
    assert member.user_id == user.id
  end
  
  test "create_room_member/2 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Chat.create_room_member(%Room{}, %User{})
  end

  test "delete_room_member/1 deletes room member" do
    member = insert(:member)
    assert {:ok, %RoomMember{}} = Chat.delete_room_member(member)
  end

  test "list_posts/1 returns all posts from chosen room" do
    room = insert(:room)
    post = insert(:post, %{room_id: room.id})

    assert Chat.list_posts(room) == [post]
  end

  test "recent_posts/2 returns all newer posts by timestamp" do
    room = insert(:room)
    posts = insert_list(3, :post, %{room_id: room.id})
    unix_timestamp = 
      Timex.now()
      |> Timex.shift(minutes: -5)
      |> Timex.to_unix()
    
    assert Chat.list_recent_posts(room, unix_timestamp) == posts
  end

  test "create_post/3 with valid data creates a post" do
    user = insert(:user)
    room = insert(:room)
    {:ok, %Post{} = post} = Chat.create_post(room, user, @post_attrs)

    assert post.message == @post_attrs.message
    assert post.user_id == user.id
    assert post.room_id == room.id
  end

  test "create_post/3 with attachment" do
    user = insert(:user)
    room = insert(:room)
    attachment = insert(:attachment)

    attrs = Map.put(@post_attrs, :attachments, [attachment.id])
    {:ok, %Post{} = post} = Chat.create_post(room, user, attrs)

    assert post.message == @post_attrs.message
    assert post.user_id == user.id
    assert post.room_id == room.id
  end

  test "create_post/3 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Chat.create_post(%Room{}, %User{}, @invalid_post_attrs)
  end
end
