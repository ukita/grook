defmodule Grook.Uploader.PostAttachment do
  use Arc.Definition
  use Arc.Ecto.Definition
  
  @versions [:original]

  def filename(_version, {file, _scope}) do
    slugify("#{file.file_name}")
  end

  def storage_dir(_version, {file, scope}) do
    "#{Application.fetch_env!(:arc, :storage_dir)}/posts/attachments/#{scope.id}"
  end

  defp slugify(str) do
    str
    |> String.downcase
    |> Path.basename(Path.extname(str))
    |> String.replace(~r/[^\w]+/u, "-")
  end
end
