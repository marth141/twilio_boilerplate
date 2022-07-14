defmodule Web.TwilioController do
  use Web, :controller
  import Plug.Conn

  def show(conn, _params) do
    token = Phone.fetch_full_access_token()

    render(conn, "show.html", token: token)
  end

  # To play something back to a caller. Used an MP3
  # Configed online at Twilio in Twiml App for when Call Button is pressed
  def mp3(conn, _params) do
    IO.inspect(conn)
    # send_resp(conn, 201, "")

    conn =
      conn
      |> put_resp_content_type("audio/mpeg")
      |> send_chunked(200)

    File.stream!("/home/kero/Videos/customer_care_voicemail_2.mp3", [], 128)
    |> Enum.into(conn)
  end

  # For having someone receive a call
  # Configed online at Twilio in Phone Number for when Twilio Number is called
  def receive(conn, _params) do
    resp = Phone.receiver_jenny()

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # For behaving like an IVR
  # Configed online at Twilio in Phone Number for when Twilio Number is called
  def ivr_welcome(conn, _params) do
    IO.inspect(conn)

    resp = Phone.phone_tree(conn)

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # For dialing a number from the Device.connect parameters
  # Configured in twilio index.html.heex
  def dial(conn, params) do
    number = params["dial"]
    resp = Phone.dial(number)

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # Adds a phone queue
  # Configed online at Twilio in Phone Number for when Twilio Number is called
  def queue(conn, _params) do
    resp = Phone.queue()

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end
end
