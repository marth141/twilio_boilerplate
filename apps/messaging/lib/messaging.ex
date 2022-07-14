defmodule Messaging do
  @moduledoc """
  Documentation for `Messaging`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Messaging.hello()
      :world

  """
  def hello do
    :world
  end

  def subscribe(topic),
    do: Phoenix.PubSub.subscribe(pub_sub(), topic)

  def publish(topic, message),
    do: Phoenix.PubSub.broadcast(pub_sub(), topic, message)

  def unsubscribe(topic),
    do: Phoenix.PubSub.unsubscribe(pub_sub(), topic)

  defp pub_sub, do: Messaging.PubSub
end
