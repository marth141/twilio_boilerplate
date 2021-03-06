defmodule Web.TwilioController do
  use Web, :controller
  import Plug.Conn

  # To play something back to a caller. Used an MP3
  # Configed online at Twilio in Twiml App for when Call Button is pressed
  def mp3(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("audio/mpeg")
      |> send_chunked(200)

    File.stream!("/home/kero/Videos/customer_care_voicemail_2.mp3", [], 128)
    |> Enum.into(conn)
  end

  # For having someone receive a call
  # Configed online at Twilio in Phone Number for when Twilio Number is called
  def receive_call(conn, _params) do
    resp = Phone.receive_call()

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # For behaving like an IVR
  # Configed online at Twilio in Phone Number for when Twilio Number is called
  def ivr_welcome(conn, _params) do
    resp = Phone.ivr_welcome(conn)

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  def ivr_planets(conn, _params) do
    resp = Phone.ivr_planets(conn)

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # For dialing a number from the Device.connect parameters
  # Configured in twilio app.js
  def dial(conn, params) do
    number = params["dial"]
    resp = Phone.dial(number)

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # Enqueues a caller
  # Configed online at Twilio in Phone Number for when Twilio Number is called
  def enqueue(conn, _params) do
    resp = Phone.enqueue()

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # For dialing a queue from the Device.connect parameters
  # Configured in twilio app.js
  def work_queue(conn, params) do
    number = params["dial"]
    resp = Phone.work_queue(number)

    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end

  # For receiving sms
  def sms(conn, _params) do
    IO.inspect(conn)

    conn
    |> put_resp_content_type("application/json")
    |> json(:ok)
  end
end
