defmodule Phone do
  @moduledoc """
  Documentation for `Phone`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Phone.hello()
      :world

  """
  def hello do
    :world
  end

  def fetch_account_sid() do
    Application.fetch_env!(:phone, :account_sid)
  end

  def fetch_auth_token() do
    Application.fetch_env!(:phone, :auth_token)
  end

  def fetch_workspace_sid() do
    Application.fetch_env!(:phone, :workspace_sid)
  end

  # Gets an outbound access token for the Twilio Device in app.js
  def fetch_outgoing_access_token() do
    ExTwilio.Capability.new()
    |> ExTwilio.Capability.allow_client_outgoing(Application.get_env(:phone, :twiml_app_sid))
    |> ExTwilio.Capability.token()
  end

  # Gets an inbound access token for the Twilio Device in app.js
  def fetch_incoming_access_token() do
    ExTwilio.Capability.new()
    |> ExTwilio.Capability.allow_client_incoming("jenny")
    |> ExTwilio.Capability.token()
  end

  # Combination of outbound and inbound access token for the Twilio Device in app.js
  def fetch_full_access_token() do
    ExTwilio.Capability.new()
    |> ExTwilio.Capability.allow_client_incoming("jenny")
    |> ExTwilio.Capability.allow_client_outgoing(Application.get_env(:phone, :twiml_app_sid))
    |> ExTwilio.Capability.token()
  end

  # Builds Twiml to route a call to the "jenny" incoming client
  def receiver_jenny() do
    import ExTwiml

    twiml do
      dial callerid: "+1XXXXXXX" do
        client("jenny")
      end
    end
  end

  # Builds Twiml for dialing a specified number
  def dial(number) do
    import ExTwiml

    twiml do
      dial(number)
      say("Goodbye")
    end
  end

  # Builds Twiml for a phone tree
  def phone_tree(conn) do
    import ExTwiml

    case conn.body_params["Digits"] do
      "1" ->
        twiml do
          say("To get to your extraction point, get on your bike and go down
          the street. Then Left down an alley. Avoid the police cars. Turn left
          into an unfinished housing development. Fly over the roadblock. Go
          passed the moon. Soon after you will see your mother ship.",
            loop: 3
          )
        end

      "2" ->
        twiml do
          say("To call the planet Broh doe As O G, press 2. To call the planet
          DuhGo bah, press 3. To call an oober asteroid to your location, press 4. To
          go back to the main menu, press the star key.",
            loop: 3
          )
        end

      _ ->
        twiml do
          gather numDigits: "1" do
            say("Thanks for calling the E T Phone Home Service. Please press 1 for
            directions. Press 2 for a list of planets to call.")
            pause(length: "3")
          end

          redirect("http://f832-66-111-121-28.ngrok.io/twilio/ivr/welcome", method: "POST")
        end
    end
  end

  # Builds Twiml for implementing a queue
  def enqueue() do
    import ExTwiml

    twiml do
      enqueue("support")
    end
  end

  # Builds Twiml for working a queue
  def queue(queue) do
    import ExTwiml

    twiml do
      dial do
        queue(queue)
      end
    end
  end
end
