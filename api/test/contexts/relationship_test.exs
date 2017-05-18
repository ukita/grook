defmodule Grook.Contexts.RelationshipTest do
  use Grook.DataCase

  alias Grook.Relationship

  test "load_user_rooms/1 returns user with rooms loaded" do
    user  = insert(:user)
    assert Relationship.load_user_rooms(user).rooms == []
  end

  test "load_user_subscriptions/1 returns user with subscriptions loaded" do
    user  = insert(:user)
    assert Relationship.load_user_subscriptions(user).subscriptions == []
  end

  test "load_user_rooms_and_subscriptions/1 returns user with rooms and subscriptions loaded" do
    user  = insert(:user)
    assert Relationship.load_user_rooms_and_subscriptions(user).rooms == []
    assert Relationship.load_user_rooms_and_subscriptions(user).subscriptions == []
  end

  test "get_user_subscriptions/1 returs all users subscriptions" do
    user = insert(:user)
    assert Relationship.get_user_subscriptions(user) == []
  end

  test "get_room_members/1 returns all rooms members" do
    room = insert(:room)
    assert Relationship.get_room_members(room) == []
  end
end
