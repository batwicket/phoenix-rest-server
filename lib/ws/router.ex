defmodule Ws.Router do
  use Phoenix.Router

  @moduledoc """
  The route definitions. The routes are defined by macros. They will be quite familiar 
  to Rails developers. To output the routes, run "mix phoenix.routes" in the application 
  directory.
  """

  # this directs the Plug module to fetch static content from the priv/static subdirectory
  plug Plug.Static, at: "/static", from: :ws

  # this handles the root URL. The resources macro may handle this as well at some point.
  # Note that it uses the Pages controller and view files.
  get "/", Ws.Controllers.Birds, :index, as: :page

  # this macro generates the RESTful interface for access to the Ws.Birds model. The 
  # routes are handled using the Birds model-view-controller components.
  # The edit and new routes are suppressed in favour of PUT.
  resources "birds", Ws.Controllers.Birds, except: [:edit, :new] do
    # you can nest resources to allow a hierarchy of urls i.e. "http:/../birds/comments/"
    # resources "comments", Controllers.Comments
  end
end
