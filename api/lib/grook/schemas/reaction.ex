defmodule Grook.Schema.Reaction do
  use Grook.Schema

  schema "reactions" do
    field :emoji_name, :string
    belongs_to :user, Grook.Schema.User
    belongs_to :post, Grook.Schema.Post

    timestamps()
  end
end
