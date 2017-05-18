defmodule Grook.Support.Helpers do
  def setup_token(user) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    
    Plug.Conn.put_req_header(
      Phoenix.ConnTest.build_conn(),
      "authorization", 
      "Bearer #{jwt}")
  end

  def render_json(module, template, assigns) do
    Phoenix.View.render(module, template, assigns) 
    |> Poison.encode!
    |> Poison.decode!
  end
end
