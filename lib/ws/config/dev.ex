defmodule Ws.Config.Dev do
  use Ws.Config

  @moduledoc """
  Developer settings
  """

  config :router, port: 4000,
                  ip: {127, 0, 0, 1},
                  ssl: false,
                  # Full error reports are enabled
                  consider_all_requests_local: true

  config :plugs, code_reload: true

  config :logger, level: :debug
end


