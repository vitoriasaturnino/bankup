defmodule Bankup.RecurringAccountsTest do
  use Bankup.DataCase

  alias Bankup.RecurringAccounts

  describe "recurring_accounts" do
    alias Bankup.RecurringAccounts.RecurringAccount

    import Bankup.RecurringAccountsFixtures

    @invalid_attrs %{status: nil, description: nil, amount: nil, due_date: nil, payee: nil, pix_key: nil}

    test "list_recurring_accounts/0 returns all recurring_accounts" do
      recurring_account = recurring_account_fixture()
      assert RecurringAccounts.list_recurring_accounts() == [recurring_account]
    end

    test "get_recurring_account!/1 returns the recurring_account with given id" do
      recurring_account = recurring_account_fixture()
      assert RecurringAccounts.get_recurring_account!(recurring_account.id) == recurring_account
    end

    test "create_recurring_account/1 with valid data creates a recurring_account" do
      valid_attrs = %{status: "some status", description: "some description", amount: 42, due_date: ~D[2024-11-01], payee: "some payee", pix_key: "some pix_key"}

      assert {:ok, %RecurringAccount{} = recurring_account} = RecurringAccounts.create_recurring_account(valid_attrs)
      assert recurring_account.status == "some status"
      assert recurring_account.description == "some description"
      assert recurring_account.amount == 42
      assert recurring_account.due_date == ~D[2024-11-01]
      assert recurring_account.payee == "some payee"
      assert recurring_account.pix_key == "some pix_key"
    end

    test "create_recurring_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecurringAccounts.create_recurring_account(@invalid_attrs)
    end

    test "update_recurring_account/2 with valid data updates the recurring_account" do
      recurring_account = recurring_account_fixture()
      update_attrs = %{status: "some updated status", description: "some updated description", amount: 43, due_date: ~D[2024-11-02], payee: "some updated payee", pix_key: "some updated pix_key"}

      assert {:ok, %RecurringAccount{} = recurring_account} = RecurringAccounts.update_recurring_account(recurring_account, update_attrs)
      assert recurring_account.status == "some updated status"
      assert recurring_account.description == "some updated description"
      assert recurring_account.amount == 43
      assert recurring_account.due_date == ~D[2024-11-02]
      assert recurring_account.payee == "some updated payee"
      assert recurring_account.pix_key == "some updated pix_key"
    end

    test "update_recurring_account/2 with invalid data returns error changeset" do
      recurring_account = recurring_account_fixture()
      assert {:error, %Ecto.Changeset{}} = RecurringAccounts.update_recurring_account(recurring_account, @invalid_attrs)
      assert recurring_account == RecurringAccounts.get_recurring_account!(recurring_account.id)
    end

    test "delete_recurring_account/1 deletes the recurring_account" do
      recurring_account = recurring_account_fixture()
      assert {:ok, %RecurringAccount{}} = RecurringAccounts.delete_recurring_account(recurring_account)
      assert_raise Ecto.NoResultsError, fn -> RecurringAccounts.get_recurring_account!(recurring_account.id) end
    end

    test "change_recurring_account/1 returns a recurring_account changeset" do
      recurring_account = recurring_account_fixture()
      assert %Ecto.Changeset{} = RecurringAccounts.change_recurring_account(recurring_account)
    end
  end
end
