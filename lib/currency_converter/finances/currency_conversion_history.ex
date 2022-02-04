defmodule CurrencyConverter.Finances.CurrencyConversionHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency_conversion_histories" do
    field :conversion_rate, :float
    field :origin_currency, :string
    field :origin_currency_value, :float
    field :target_currency, :string
    field :target_currency_value, :float
    belongs_to :user, CurrencyConverter.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(currency_conversion_history, attrs) do
    currency_conversion_history
    |> cast(attrs, [:origin_currency, :origin_currency_value, :target_currency_value, :target_currency, :conversion_rate, :user_id])
    |> validate_required([:origin_currency, :origin_currency_value, :target_currency_value, :target_currency, :conversion_rate, :user_id])
  end
end
