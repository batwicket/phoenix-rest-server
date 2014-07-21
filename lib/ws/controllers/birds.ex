
defmodule Ws.Controllers.Birds do
  use Phoenix.Controller
  require Ws.Models.Bird
  require Ws.ControllerUtils

  @doc """
  GET http://.../birds
  """
  def index(conn, %{}) do
    bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)
    Ws.ControllerUtils.json_resp conn, birds: bird_list
  end

  defp findBirdStructInList([], _bird_name) do
    nil
  end

  @doc """
  Finds an entry in bird list.
  """
  defp findBirdStructInList([head | tail], bird_name) do
    head_name = head.name
    if(head_name === bird_name) do
      head
    else
      findBirdStructInList(tail, bird_name)
    end
  end


  defp deleteBirdStructInListHelper([], _bird_name, found, new_list) do
    {found, new_list}
  end

  defp deleteBirdStructInListHelper([head | tail], bird_name, found, new_list) do
    head_name = head.name
    if(head_name === bird_name) do
      newer_list = new_list
      new_found = true
    else
      newer_list = new_list ++ [head]
      new_found = found
    end
    {_found, _updated_list} = deleteBirdStructInListHelper(tail, bird_name, new_found, newer_list)
  end

  @doc """
  Deletes an entry in bird list.
  """
  defp deleteBirdStructInList(bird_list, bird_name) do
    {_found, _new_list} = deleteBirdStructInListHelper(bird_list, bird_name, false, [])
  end


  defp updateBirdStructInListHelper([], _bird_name, _newBird, found, new_list) do
    {found, new_list}
  end

  defp updateBirdStructInListHelper([head | tail], bird_name, new_bird, found, new_list) do
    head_name = head.name
    if(head_name === bird_name) do
      newer_list = new_list ++ [new_bird]
      new_found = true
    else
      newer_list = new_list ++ [head]
      new_found = found
    end
    {_found, _updated_list} = updateBirdStructInListHelper(tail, bird_name, new_bird, new_found, newer_list)
  end

  @doc """
  Updates an entry in bird list.
  """
  defp updateBirdStructInList(bird_list, bird_name, new_bird) do
    {_found, _new_list} = updateBirdStructInListHelper(bird_list, bird_name, new_bird, false, [])
  end


  defp addBirdStructsToList([]) do
  end

  @doc """
  Adds list entries to bird list. The list entries contain structs so no
  conversion is necessary.
  """
  defp addBirdStructsToList([head | tail]) do
    new_bird = %Ws.Models.Bird{name: head.name, type: head.type, age: head.age}
    :gen_server.cast(:bird_data_server_pid, {:add_entry, new_bird})
    addBirdStructsToList(tail)
  end


  defp addBirdsToList([]) do
  end

  @doc """
  Adds list entries to bird list. The list entries contain maps rather than structs so
  conversion is necessary.
  """
  defp addBirdsToList([head | tail]) do
    new_bird = %Ws.Models.Bird{name: head["name"], type: head["type"], age: head["age"]}
    :gen_server.cast(:bird_data_server_pid, {:add_entry, new_bird})
    addBirdsToList(tail)
  end


  @doc """
  GET http://.../birds/:id. Returns an entry.
  N.B. The client MUST NOT set Content-Type to application/json in the
       request header
  Returns 200 on success
  Returns 404 if entry is not in the list
  """
  def show(conn, _request_body) do
    bird_id = conn.params["id"]
    bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)
    bird = findBirdStructInList(bird_list, bird_id)
    if(bird) do
      status = 200
    else
      status = 404
    end
    Ws.ControllerUtils.json_resp conn, bird, status
  end

  @doc """
  POST http://.../birds. Replaces entire list.
  N.B. The client MUST set Content-Type to application/json in the
       request header and the new bird values in the request body i.e.
       {"birds":[{"name": "Phyre", "type": "phoenix", "age":17}]}
  Returns 201 on success.
  Returns 400 for invalid request body.
  """
  def create(conn, request_body) do
    new_bird_list = request_body["birds"]
    if(new_bird_list == nil) do
      status = 400
    else
      :gen_server.cast(:bird_data_server_pid, {:del_all_entries})
      addBirdsToList(new_bird_list)
      status = 201
    end	
    bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)
    Ws.ControllerUtils.json_resp conn, bird_list, status
  end

  @doc """
  PUT http://.../birds/:id. Updates an entry in list. If the entry is 
  not in the list it is added. If fields are missing in the
  JSON request body then the defaults are used for those fields.
  N.B. The client MUST set Content-Type to application/json in the
       request header and the new bird values in the request body i.e.
       {"name": "Phyre", "type": "phoenix", "age":17}
  Returns 200 on update.
  Returns 201 on create.
  Returns 400 for invalid request body.
  """
  def update(conn, request_body) do
    bird_id = conn.params["id"]
    bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)

    if(bird_id !== request_body["name"]) do
      status = 400
    else
      new_bird = %Ws.Models.Bird{name: request_body["name"], type: request_body["type"], age: request_body["age"]}

      {found, new_bird_list} = updateBirdStructInList(bird_list, bird_id, new_bird)
      if(found) do
        :gen_server.cast(:bird_data_server_pid, {:del_all_entries})
        addBirdStructsToList(new_bird_list)
        status = 200
      else
        _new_list = :gen_server.cast(:bird_data_server_pid, {:add_entry, new_bird})
        status = 201
      end
    end

    # don't fetch/return the list if you want speed
    bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)
    Ws.ControllerUtils.json_resp conn, bird_list, status
  end

  @doc """
  DELETE http://.../birds/:id. Deletes an entry in list.
  Returns 404 if entry is not in the list
  """
  def destroy(conn, _request_body) do
    bird_id = conn.params["id"]
    bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)
    {found, new_bird_list} = deleteBirdStructInList(bird_list, bird_id)
    if(found) do
      :gen_server.cast(:bird_data_server_pid, {:del_all_entries})
      addBirdStructsToList(new_bird_list)
      status = 200
    else
      status = 404
    end
    current_bird_list = :gen_server.call(:bird_data_server_pid, :list_entries)
    Ws.ControllerUtils.json_resp conn, current_bird_list, status
  end
end
