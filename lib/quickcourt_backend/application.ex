defmodule QuickcourtBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    IO.puts "ENV:"
    IO.inspect System.get_env

    Logger.info "ENV:"
    Logger.info System.get_env

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      QuickcourtBackend.Repo,
      # Start the endpoint when the application starts
      QuickcourtBackendWeb.Endpoint
      # Starts a worker by calling: QuickcourtBackend.Worker.start_link(arg)
      # {QuickcourtBackend.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QuickcourtBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QuickcourtBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
