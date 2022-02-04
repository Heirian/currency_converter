defmodule CurrencyConverter.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias CurrencyConverter.Repo

  alias CurrencyConverter.Finances.CurrencyConversionHistory

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
end
