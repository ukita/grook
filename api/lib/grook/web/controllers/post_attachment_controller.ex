defmodule Grook.Web.PostAttachmentController do
  use Grook.Web, :controller

  alias Grook.Chat
  alias Grook.Schema.PostAttachment

  action_fallback Grook.Web.FallbackController

  def create(conn, %{"attachment" => attachment_params}) do
    with {:ok, %PostAttachment{} = attachment} <- Chat.create_attachment(attachment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", attachment: attachment)
    end
  end
end
