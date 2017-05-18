defmodule Grook.Schema.Post do
  use Grook.Schema

  schema "posts" do
    field :message, :string

    belongs_to :user, Grook.Schema.User
    belongs_to :room, Grook.Schema.Room
    has_many :attachments, Grook.Schema.PostAttachment

    timestamps()
  end
end
