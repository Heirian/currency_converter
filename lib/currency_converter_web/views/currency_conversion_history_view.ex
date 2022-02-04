defmodule CurrencyConverterWeb.CurrencyConversionHistoryView do
  use CurrencyConverterWeb, :view

  def render("index.json", %{currency_conversion_histories: currency_conversion_histories}) do
    %{data: render_many(currency_conversion_histories, __MODULE__, "currency_conversion_history.json")}
  end

  def render("show.json", %{currency_conversion_history: currency_conversion_history}) do
    %{data: render_one(currency_conversion_history, __MODULE__, "currency_conversion_history.json")}
  end

  def render("error_handler.json", %{response: response}) do
    response.body
  end

  def render("currency_conversion_history.json", %{currency_conversion_history: currency_conversion_history}) do
    %{
      conversion_rate: currency_conversion_history.conversion_rate,
      date: currency_conversion_history.inserted_at,
      id: currency_conversion_history.id,
      origin_currency: currency_conversion_history.origin_currency,
      origin_currency_value: currency_conversion_history.origin_currency_value,
      target_currency: currency_conversion_history.target_currency,
      target_currency_value: currency_conversion_history.target_currency_value,
      user_id: currency_conversion_history.user_id
    }
  end
end
