defmodule CurrencyConverter.Repo.Migrations.CreateCurrencyConversionHistories do
  use Ecto.Migration

  def change do
    create table(:currency_conversion_histories) do
      add :origin_currency, :string
      add :origin_currency_value, :float
      add :target_currency_value, :float
      add :target_currency, :string
      add :conversion_rate, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:currency_conversion_histories, [:user_id])
  end
end
