defmodule Ws.Config do
  use Phoenix.Config.App

  @moduledoc """
  These settings are overridden by conflicting dev and prod settings.
  """
  
  config :router, port: 4000

  config :plugs, code_reload: false

  config :logger, level: :error
end


