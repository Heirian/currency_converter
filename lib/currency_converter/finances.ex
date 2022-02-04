defmodule CurrencyConverter.Finances do
  @moduledoc """
  The Finances context.
  """
  use Tesla

  import Ecto.Query, warn: false
  alias CurrencyConverter.Repo

  alias CurrencyConverter.Finances.CurrencyConversionHistory

  plug Tesla.Middleware.BaseUrl, "http://api.exchangeratesapi.io/v1"
  plug Tesla.Middleware.Headers, [{"Authorization", ""}]
  plug Tesla.Middleware.JSON

  @exchangeratesapi_key Application.get_env(:currency_converter, CurrencyConverter.Finances)[:secret_key]

  def create_currency_conversion_history(user, attrs) do
    user
    |> Ecto.build_assoc(:currency_conversion_histories)
    |> CurrencyConversionHistory.changeset(attrs)
    |> Repo.insert()
  end

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
    |> Repo.preload(:currency_conversion_histories)
  end

  def get_currency_rate(origin, target) do
    get("/latest?access_key=" <> @exchangeratesapi_key <> "&base=" <> origin <> "&symbols=" <> target)
  end
end
