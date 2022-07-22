defmodule Web.TwilioLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    token = Phone.fetch_full_access_token()

    {:ok,
     socket
     |> assign(number: "+16054756962")
     |> assign(queue: "support")
     |> assign(token: token)
     |> assign(
       :button_class,
       "inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
     )}
  end
end
