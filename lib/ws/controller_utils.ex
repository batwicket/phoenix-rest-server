defmodule Ws.ControllerUtils do
  import Phoenix.Controller

  @doc """
  Decodes JSON.
  """
  def json_decode(json) do
    {:ok, data} = JSEX.decode(json)
    data
  end

  @doc """
  Encodes JSON.
  """
  def json_encode(data) do
    {:ok, json} = JSEX.encode(data)
    json
  end

  @doc """
  Responds to HTTP request.
  """
  def json_resp(conn, data, status \\ 200) do
    json conn, status, json_encode(data)
  end

end
