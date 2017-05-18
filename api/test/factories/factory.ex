defmodule Grook.Factory do
  use ExMachina.Ecto, repo: Grook.Repo

  def user_factory do
    %Grook.Schema.User{
      active: true,
      name: "John Doe",
      username: sequence(:username, &"username#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "secretpass"
    }
  end

  def set_password(user, password) do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(password)
    %{user | password_hash: hashed_password}
  end

  def room_factory do
    %Grook.Schema.Room{
      active: true,
      topic: "What is the meaning of life?",
      description: "Maybe 42?",
      owner_id: insert(:user).id
    }
  end

  def post_factory do
    %Grook.Schema.Post{
      room_id: insert(:room).id,
      user_id: insert(:user).id,
      message: sequence(:message, &"message number #{&1}")
    }
  end

  def attachment_factory do
    %Grook.Schema.PostAttachment{
      file: nil
    }
  end

  def member_factory do
    %Grook.Schema.RoomMember{
      room_id: insert(:room).id,
      user_id: insert(:user).id
    }
  end

  def reaction_factory do
    %Grook.Schema.Reaction{
      post_id: insert(:post).id,
      user_id: insert(:user).id
    }
  end
end
