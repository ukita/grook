defmodule Grook.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Grook.Repo

  alias Grook.Schema.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert
  end

  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update
  end

  def delete_user(user), do: Repo.delete(user)

  def get_user!(user_id), do: Repo.get!(User, user_id)
  def get_user(user_id), do: Repo.get(User, user_id)
  
  def login_user_by_credentials(username, password) do
    user = 
      Repo.one(find_user_for_authentication(username))

    cond do
      user && Comeonin.Bcrypt.checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Comeonin.Bcrypt.dummy_checkpw
        {:error, :forbidden}
    end
  end

  def find_user_for_authentication(identification) do
    from u in User,
      where: u.email == ^identification,
      or_where: u.username == ^identification,
      limit: 1
  end

  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, required: true)
    |> validate_format(:username, Grook.Regexp.username)
    |> unique_constraint(:username)
    |> validate_format(:email, Grook.Regexp.email)
    |> unique_constraint(:email)
    |> put_pass_hash
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
