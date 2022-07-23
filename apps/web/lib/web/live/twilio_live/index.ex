defmodule Web.TwilioLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    dialer_token = Phone.fetch_dialer_access_token()
    queue_token = Phone.fetch_queue_access_token()

    {:ok,
     socket
     |> assign(number: "+16054756962")
     |> assign(queue: "support")
     |> assign(dialer_token: dialer_token)
     |> assign(queue_token: queue_token)
     |> assign(
       :button_class,
       "inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
     )}
  end
end
