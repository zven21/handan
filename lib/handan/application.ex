defmodule Handan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HandanWeb.Telemetry,
      Handan.Repo,
      {DNSCluster, query: Application.get_env(:handan, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Handan.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Handan.Finch},
      # Start a worker by calling: Handan.Worker.start_link(arg)
      # {Handan.Worker, arg},
      # Start to serve requests, typically the last entry
      Handan.EventApp,
      Handan.Enterprise.Supervisor,
      Handan.Accounts.Supervisor,
      Handan.Stock.Supervisor,
      Handan.Selling.Supervisor,
      Handan.Purchasing.Supervisor,
      HandanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Handan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HandanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
