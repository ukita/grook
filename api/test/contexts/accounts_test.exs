defmodule Grook.Contexts.AccountsTest do
  use Grook.DataCase

  alias Grook.Accounts
  alias Grook.Schema.User

  @attrs %{email: "johndoe@example.com", name: "John Doe", username: "johndoe", password: "weakpass", password_confirmation: "weakpass"}
  @invalid_attrs %{email: nil, name: nil, username: nil, password: nil}

  test "get_user! returns the user with given id" do
    user = insert(:user)
    assert Accounts.get_user!(user.id).id == user.id
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Accounts.create_user(@attrs)
    assert user.email == "johndoe@example.com"
    assert user.name == "John Doe"
    assert user.username == "johndoe"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = insert(:user)
    assert {:ok, %User{} = user} = Accounts.update_user(user, @attrs)
    
    assert user.email == "johndoe@example.com"
    assert user.name == "John Doe"
    assert user.username == "johndoe"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = insert(:user)
    assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    assert user.id == Accounts.get_user!(user.id).id
  end

  test "delete_user/1 deletes the user" do
    user = insert(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = insert(:user)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end

  test "login_user_by_credentials/2 using username returns user with valid credentials" do
    user = build(:user) |> set_password("secret123") |> insert()
    {:ok, logged_user} = Accounts.login_user_by_credentials(user.username, "secret123")

    assert user.id == logged_user.id
  end

  test "login_user_by_credentials/2 using email returns user with valid credentials" do
    user = build(:user) |> set_password("secret123") |> insert()
    {:ok, logged_user} = Accounts.login_user_by_credentials(user.email, "secret123")

    assert user.id == logged_user.id
  end

  test "login_user_by_credentials/2 returns error with invalid identification" do
    build(:user) |> set_password("secret123") |> insert()
    assert {:error, :forbidden} = Accounts.login_user_by_credentials("superuser", "secret123")
  end

  test "login_user_by_credentials/2 returns error with invalid password" do
    user = build(:user) |> set_password("secret123") |> insert()
    assert {:error, :unauthorized} = Accounts.login_user_by_credentials(user.username, "123secret")
  end
end
