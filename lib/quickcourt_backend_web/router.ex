defmodule QuickcourtBackendWeb.Router do
  use QuickcourtBackendWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug(QuickcourtBackendWeb.Plugs.Context)
  end

  scope "/" do
    pipe_through :api

    forward("/graphql", Absinthe.Plug, schema: QuickcourtBackendWeb.Schema)

    # TODO: Enable this in the future
    # if Mix.env() == :dev do
    #   forward "/graphiql", Absinthe.Plug.GraphiQL,
    #   schema: QuickcourtBackendWeb.Schema,
    #   interface: :simple,
    #   context: %{pubsub: QuickcourtBackendWeb.Endpoint}
    # end

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: QuickcourtBackendWeb.Schema,
      interface: :advanced,
      context: %{pubsub: QuickcourtBackendWeb.Endpoint}
  end
end
