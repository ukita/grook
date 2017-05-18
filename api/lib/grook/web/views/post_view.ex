defmodule Grook.Web.PostView do
  use Grook.Web, :view
  alias Grook.Web.{PostView, PostAttachmentView, UserView}

  def render("index.json", %{posts: posts}) do
    %{posts: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{post: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      user: render_one(post.user, UserView, "user.json"),
      message: post.message,
      attachments: render_many(post.attachments, PostAttachmentView, "attachment.json"),
      created_at: post.inserted_at}
  end
end
