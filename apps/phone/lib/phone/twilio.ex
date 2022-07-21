defmodule Phone.Twilio do
  def read_multiple_queue_resources() do
    with {:ok, %{body: body, status: 200}} <-
           Finch.build(
             :get,
             "https://api.twilio.com/2010-04-01/Accounts/#{Phone.fetch_account_sid()}/Queues.json?PageSize=20",
             [
               {"Authorization",
                "Basic #{Base.encode64("#{Phone.fetch_account_sid()}:#{Phone.fetch_auth_token()}")}"}
             ]
           )
           |> Finch.request(TwilioFinch),
         {:ok, queues} <- Jason.decode(body) do
      queues
    end
  end

  def read_multiple_member_resources(queue_sid) do
    with {:ok, %{body: body, status: 200}} <-
           Finch.build(
             :get,
             "https://api.twilio.com/2010-04-01/Accounts/#{Phone.fetch_account_sid()}/Queues/#{queue_sid}/Members.json",
             [
               {"Authorization",
                "Basic #{Base.encode64("#{Phone.fetch_account_sid()}:#{Phone.fetch_auth_token()}")}"}
             ]
           )
           |> Finch.request(TwilioFinch),
         {:ok, queues} <- Jason.decode(body) do
      queues
    end
  end
end
