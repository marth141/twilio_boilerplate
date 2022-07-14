defmodule Db.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Db.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Db.PubSub}
      # Start a worker by calling: Db.Worker.start_link(arg)
      # {Db.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Db.Supervisor)
  end
end
