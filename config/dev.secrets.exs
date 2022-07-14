import Config

# Configures Twilio in apps/phone
config :ex_twilio,
  account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
  auth_token: System.get_env("TWILIO_AUTH_TOKEN")
  # optional
  # workspace_sid: System.fetch_env!("TWILIO_WORKSPACE_SID")

config :phone,
  twiml_app_sid: System.get_env("TWIML_APP_SID")
