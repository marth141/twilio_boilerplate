defmodule Phone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Phone.Worker.start_link(arg)
      # {Phone.Worker, arg}
      {Finch, name: TwilioFinch},
      {Registry, name: Phone.MyRegistry, keys: :unique},
      {DynamicSupervisor, name: Phone.MyDynamicSupervisor, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phone.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
