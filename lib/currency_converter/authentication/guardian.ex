defmodule CurrencyConverter.Guardian do
  use Guardian, otp_app: :currency_converter
  alias CurrencyConverter.Accounts

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_by_id!(id)
    {:ok, resource}
  end
end
