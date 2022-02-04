defmodule CurrencyConverter.AccountsTest do
  use CurrencyConverter.DataCase

  alias CurrencyConverter.Accounts

  describe "users" do
    alias CurrencyConverter.Accounts.User

    @valid_attrs %{email: "some_email@test.com", password: "some_pass"}
    @invalid_attrs %{email: nil, password: nil}

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some_email@test.com"
      assert Bcrypt.verify_pass("some_pass", user.password)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "email is required" do
      changeset = User.registration_changeset(%User{}, Map.delete(@valid_attrs, :email))
      refute changeset.valid?
    end

    test "email must contain a valid format" do
      attrs = %{@valid_attrs | email: "fooexample.com"}
      changeset = User.registration_changeset(%User{}, attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "email is uniq" do
      user = User.registration_changeset(%User{}, @valid_attrs)
      assert {:ok, _user } = Repo.insert(user)

      imposter = User.registration_changeset(%User{}, @valid_attrs)

      assert {:error, changeset} = Repo.insert(imposter)
      assert changeset.errors[:email] == {"has already been taken", [{:constraint, :unique}, {:constraint_name, "users_email_index"}]}
    end

    test "password is required" do
      changeset = User.registration_changeset(%User{}, Map.delete(@valid_attrs, :password))
      refute changeset.valid?
    end

    test "password must be at least six characters long" do
      attrs = %{@valid_attrs | password: "tests"}
      changeset = User.registration_changeset(%User{}, attrs)
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    end
  end
end
