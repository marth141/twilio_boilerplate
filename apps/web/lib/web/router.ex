defmodule Web.Router do
  use Web, :router

  import Web.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/twilio", Web do
    pipe_through :browser

    live "/", TwilioLive.Index, :index
  end

  scope "/twilio/api", Web do
    pipe_through :api
    # When dialed, will enqueue the caller
    # Configed online at Twilio in Phone Number for when Twilio Number is called
    post "/enqueue", TwilioController, :enqueue
    # When dialed, will allow an agent to answer a queue'd call
    # Configed online at Twilio in Twiml App for when Work Queue Button is pressed
    post "/work_queue", TwilioController, :work_queue
    # To make a call and get some MP3 response
    # Configed online at Twilio in Twiml App for when Call Button is pressed
    post "/mp3", TwilioController, :mp3
    # To dial some number when the call button is pressed if configured that way
    # Configed online at Twilio in Twiml App for when Call Button is pressed
    post "/dial", TwilioController, :dial
    # To receive a call and have a 2 way call
    # Configed online at Twilio in Phone Number for when Twilio Number is called
    post "/receive_call", TwilioController, :receive_call
    # To behave like an IVR
    # Configed online at Twilio in Twiml App and Phone Number
    post "/ivr/welcome", TwilioController, :ivr_welcome
    post "/ivr/planets", TwilioController, :ivr_planets
    # To get SMS
    post "/sms", TwilioController, :sms
  end

  # Other scopes may use custom stacks.
  scope "/api", Web do
    pipe_through :api
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Web.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", Web do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", Web do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", Web do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
