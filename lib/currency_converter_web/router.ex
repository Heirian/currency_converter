defmodule CurrencyConverterWeb.Router do
  use CurrencyConverterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CurrencyConverter.Guardian.AuthPipeline
  end

  scope "/api", CurrencyConverterWeb do
    pipe_through :api

    post "/users", UserController, :register
    post "/session/new", SessionController, :new
  end

  scope "/api", CurrencyConverterWeb do
    pipe_through [:api, :auth]

    post "/session/refresh", SessionController, :refresh
    post "/session/delete", SessionController, :delete
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
