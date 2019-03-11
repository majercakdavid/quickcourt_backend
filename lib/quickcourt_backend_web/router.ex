defmodule QuickcourtBackendWeb.Router do
  use QuickcourtBackendWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "https://qc-web-app-demo.herokuapp.com/"
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: QuickcourtBackendWeb.Schema,
      interface: :simple,
      context: %{pubsub: QuickcourtBackendWeb.Endpoint}
  end
end
