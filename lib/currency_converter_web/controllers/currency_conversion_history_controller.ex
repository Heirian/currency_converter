defmodule CurrencyConverterWeb.CurrencyConversionHistoryController do
  use CurrencyConverterWeb, :controller

  alias CurrencyConverter.Finances

  action_fallback CurrencyConverterWeb.FallbackController

  def index(conn, _params) do
    user = Finances.current_user(conn)
    conn
    |> put_status(:ok)
    |> render("index.json", %{currency_conversion_histories: user.currency_conversion_histories})
  end

  def create(conn, %{"origin_currency" => origin_currency, "target_currency" => target_currency, "origin_currency_value" => origin_currency_value}) do
    user = Guardian.Plug.current_resource(conn)
    {:ok, response} = Finances.get_currency_rate(origin_currency, target_currency)
      case response.body["success"] do
        true ->
          rate = response.body["rates"][target_currency]
          target_currency_value = origin_currency_value * rate
          attrs = %{origin_currency: origin_currency, target_currency: target_currency, origin_currency_value: origin_currency_value, target_currency_value: target_currency_value, conversion_rate: rate}

          with {:ok, currency_conversion_history} <- Finances.create_currency_conversion_history(user, attrs) do
            conn
            |> put_status(:created)
            |> render("show.json", currency_conversion_history: currency_conversion_history)
          end
        false ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error_handler.json", response: response)
      end
  end
end
