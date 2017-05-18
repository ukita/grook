defmodule Grook.Schema.PostAttachment do
  use Grook.Schema

  schema "posts_attachments" do
    field :file, Grook.Uploader.PostAttachment.Type
    belongs_to :post, Grook.Schema.Post

    timestamps()
  end
end
