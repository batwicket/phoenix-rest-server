defmodule Ws.Config.Prod do
  use Ws.Config

  @moduledoc """
  Production settings
  """

  config :router, port: 4000,
                  ssl: false,
                  ip: {127, 0, 0, 1},
                  # Full error reports are disabled
                  consider_all_requests_local: false

  config :plugs, code_reload: false

  config :logger, level: :error
end
