defmodule Web.TwilioLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    Phone.start_queue_agent(Phone.MyRegistry, Phone.MyDynamicSupervisor, "support")
    dialer_token = Phone.fetch_dialer_access_token()
    queue_token = Phone.fetch_queue_access_token()

    {:ok,
     socket
     |> assign(number: "+16054756962")
     |> assign(queue: "support")
     |> assign(dialer_token: dialer_token)
     |> assign(queue_token: queue_token)
     |> assign(queue_status: "")
     |> assign(
       :button_class,
       "inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs font-medium rounded shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
     )}
  end

  @impl true
  def handle_event("decrement-queue", _, socket) do
    decrement_queue_agent(Phone.MyRegistry, "support")
    queue_status = read_queue_agent(Phone.MyRegistry, "support")

    {:noreply,
     socket
     |> assign(:queue_status, queue_status)}
  end

  @impl true
  def handle_info(:tick, socket) do
    queue_status = read_queue_agent(Phone.MyRegistry, "support")

    {:noreply,
     socket
     |> assign(:queue_status, queue_status)}
  end

  defp decrement_queue_agent(registry, registry_key) do
    [{pid, _}] = Registry.lookup(registry, registry_key)
    Phone.SupportQueue.decrement(pid)
  end

  defp read_queue_agent(registry, registry_key) do
    [{pid, _}] = Registry.lookup(registry, registry_key)
    Phone.SupportQueue.value(pid)
  end
end
