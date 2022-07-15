defmodule Web.TwilioLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    token = Phone.fetch_full_access_token()

    {:ok,
     socket
     |> assign(number: "+16054756962")
     |> assign(queue: "support")
     |> assign(token: token)}
  end
end
