defmodule Messaging.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Messaging.Worker.start_link(arg)
      # {Messaging.Worker, arg}
      {Phoenix.PubSub, [name: Messaging.PubSub, adapter: Phoenix.PubSub.PG2]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Messaging.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
