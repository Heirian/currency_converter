defmodule CurrencyConverter.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  schema "users" do
    field :email, :string
    field :password, :string
    has_many :currency_conversion_histories, CurrencyConverter.Finances.CurrencyConversionHistory

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 6)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 6)
    |> encrypt_and_put_password()
  end

  defp encrypt_and_put_password(user) do
    with password <- fetch_field!(user, :password) do
      cond do
        is_binary(password) ->
          encrypted_password = Bcrypt.hash_pwd_salt(password)
          put_change(user, :password, encrypted_password)
        true ->
          put_change(user, :password, "")
      end
    end
  end
end
