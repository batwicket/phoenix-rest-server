defmodule Ws.Supervisor do
  use Supervisor

  @moduledoc """
  The standard top-level supervisor extended to monitor the Model process.
  """

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  @doc """
  Called during startup of Phoenix application. The default implementation has
  been modified to launch the Model process.
  """
  def init([]) do
    children = [worker(Ws.Models.Birds, [])]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end
