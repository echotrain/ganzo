defmodule Ganzo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GanzoWeb.Telemetry,
      Ganzo.Repo,
      {DNSCluster, query: Application.get_env(:ganzo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ganzo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ganzo.Finch},
      # Start a worker by calling: Ganzo.Worker.start_link(arg)
      # {Ganzo.Worker, arg},
      # Start to serve requests, typically the last entry
      GanzoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ganzo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GanzoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
