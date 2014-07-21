defmodule Ws.Models.Bird do
  @moduledoc """
  A model entry. A struct is currently the preferred data structure vs, say, a record.
  """
  defstruct name: "<new>", type: "<type>", age: 0
end

defmodule Ws.Models.Birds do
  require Ws.Models.Bird
  use GenServer

  @moduledoc """
  Demonstrates a simple Model consisting of a list of structs. In practice the data
  would be stored using ecto, Riak, or some other persistent store. The standard
  Ws.Supervisor has been extended to add this process as a child.
  """

  @doc """
  Called by Ws.Supervisor, which also supervises the Phoenix application process
  """
  def start_link do
	  
	# create an initial entry
	tim = %Ws.Models.Bird{name: "Phyre", type: "phoenix", age: 17}
    initial_entries = [tim]
	
    # delegate to OTP. initial_entries will be passed to Ws.Models.Birds.init/1
    :gen_server.start_link({:local, :bird_data_server_pid}, __MODULE__, initial_entries, [])
  end

  @doc """
  Called by OTP with the initial list of birds
  """
  def init(initial_entries) do
    {:ok, initial_entries}
  end


  # Private convenience methods. Alternatively you can expose these to clients and have them
  # accept a PID argument so that handle_call/handle_cast can be called. This would expose
  # two functions to the global namespace for each call so on general principles it is not
  # done here.

  @doc """
  Add a bird. Convenience function.
  """
  defp add(entries, new_entry) do
     [new_entry | entries]
   end

  @doc """
  Delete a bird. Convenience function.
  """
  defp del(entries, ex_entry) do
    if Enum.any?(entries, fn(x) -> x == ex_entry end) do
      List.delete(entries, ex_entry)
    else
      entries
    end
  end


  # GenServer API. The following functions are called by OTP in response to a client request.

  @doc """
  List birds
  """
  def handle_call(:list_entries, _from, entries) do
    {:reply, entries, entries}
  end

  @doc """
  Add a bird
  """
  def handle_cast({:add_entry, new_entry}, entries) do
    {:noreply, add(entries, new_entry)}
  end

  @doc """
  Delete a bird
  """
  def handle_cast({:del_entry, ex_entry}, entries) do
    {:noreply, del(entries, ex_entry)}
  end

  @doc """
  Delete all birds
  """
  def handle_cast({:del_all_entries}, entries) do
    {:noreply, []}
  end
end
