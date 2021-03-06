defmodule Phone do
  @moduledoc """
  Documentation for `Phone`.
  """

  @ngrok "http://9a46-66-111-121-28.ngrok.io"

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
    Application.fetch_env!(:ex_twilio, :account_sid)
  end

  def fetch_auth_token() do
    Application.fetch_env!(:ex_twilio, :auth_token)
  end

  def fetch_workspace_sid() do
    Application.fetch_env!(:ex_twilio, :workspace_sid)
  end

  # Combination of outbound and inbound access token for the Twilio Device in app.js
  def fetch_dialer_access_token() do
    ExTwilio.Capability.new()
    |> ExTwilio.Capability.allow_client_incoming("jenny")
    |> ExTwilio.Capability.allow_client_outgoing(
      Application.get_env(:phone, :twiml_dialer_app_sid)
    )
    |> ExTwilio.Capability.token()
  end

  def fetch_queue_access_token() do
    ExTwilio.Capability.new()
    |> ExTwilio.Capability.allow_client_outgoing(
      Application.get_env(:phone, :twiml_queue_app_sid)
    )
    |> ExTwilio.Capability.token()
  end

  # Builds Twiml to route a call to the "jenny" incoming client
  def receive_call() do
    import ExTwiml

    twiml do
      dial callerId: "+1XXXXXXXXXX" do
        client("jenny")
      end
    end
  end

  # Builds Twiml for dialing a specified number
  def dial(number_to_dial) do
    import ExTwiml

    twiml do
      dial(number_to_dial, callerId: "+19294302984")
    end
  end

  # Builds Twiml for a phone tree
  def ivr_welcome(conn) do
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

          pause(length: "3")
        end

      "2" ->
        twiml do
          redirect("#{@ngrok}/twilio/api/ivr/planets", method: "POST")
        end

      _ ->
        twiml do
          gather numDigits: "1" do
            say("Thanks for calling the E T Phone Home Service. Please press 1 for
            directions. Press 2 for a list of planets to call.")
            pause(length: "3")
          end

          redirect("#{@ngrok}/twilio/api/ivr/welcome", method: "POST")
        end
    end
  end

  def ivr_planets(conn) do
    import ExTwiml

    case conn.body_params["Digits"] do
      "*" ->
        twiml do
          redirect("#{@ngrok}/twilio/api/ivr/welcome", method: "POST")
        end

      "2" ->
        twiml do
          say("Hello thank you for calling Broh doe As O G. We are not available good bye.")

          pause(length: "3")
        end

      "3" ->
        twiml do
          say(
            "Hello thank you for calling Duhgo bah. Yoda is being a swamp hick and won't answer the phone. May the force be with you."
          )

          pause(length: "3")
        end

      "4" ->
        twiml do
          say(
            "Hello thank you for calling oober asteroid. We know your location and will be there in 1 million years. Good bye."
          )

          pause(length: "3")
        end

      "5" ->
        enqueue()

      _ ->
        twiml do
          gather numDigits: "1" do
            say("To call the planet Broh doe As O G, press 2. To call the planet
            DuhGo bah, press 3. To call an oober asteroid to your location, press 4.
            To be put on hold in the support queue, press 5. To go back to the
            main menu, press the star key.")
            pause(length: "3")
            redirect("#{@ngrok}/twilio/api/ivr/planets", method: "POST")
          end
        end
    end
  end

  # Builds Twiml for implementing a queue
  def enqueue() do
    [{support_queue_pid, _}] = registry_lookup(Phone.MyRegistry, "support")

    agent_counter_increment(support_queue_pid)

    import ExTwiml

    twiml do
      enqueue("support")
    end
  end

  # Builds Twiml for working a queue
  def work_queue(queue) do
    import ExTwiml

    twiml do
      dial do
        queue(queue)
      end
    end
  end

  def start_queue_agent(registry, dynamic_supervisor, registry_key, opts \\ []) do
    registry_value = Keyword.get(opts, :registry_value, nil)

    name = {:via, Registry, {registry, registry_key, registry_value}}

    DynamicSupervisor.start_child(
      dynamic_supervisor,
      {Phone.SupportQueue, name: name}
    )
  end

  defp agent_counter_increment(pid) do
    Phone.SupportQueue.increment(pid)
  end

  defp registry_lookup(registry, registry_key) do
    Registry.lookup(registry, registry_key)
  end
end
