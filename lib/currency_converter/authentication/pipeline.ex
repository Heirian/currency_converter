defmodule CurrencyConverter.Guardian.AuthPipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :currency_converter,
    module: CurrencyConverter.Guardian,
    error_handler: CurrencyConverter.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, claims: @claims, scheme: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)
end
