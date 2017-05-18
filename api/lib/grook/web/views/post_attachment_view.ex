defmodule Grook.Web.PostAttachmentView do
  use Grook.Web, :view
  alias Grook.Web.PostAttachmentView

  def render("show.json", %{attachment: attachment}) do
    %{attachment: render_one(attachment, PostAttachmentView, "attachment.json")}
  end

  def render("attachment.json", %{post_attachment: attachment}) do
    %{id: attachment.id,
      name: attachment.file.file_name,
      file: file_urls(attachment),
      created_at: attachment.inserted_at}
  end

  def file_urls(attachment) do
    Grook.Uploader.PostAttachment.urls({
      attachment.file,
      attachment
    })
  end
end
