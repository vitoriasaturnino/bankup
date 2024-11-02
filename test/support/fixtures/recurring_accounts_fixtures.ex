defmodule Bankup.RecurringAccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankup.RecurringAccounts` context.
  """

  @doc """
  Generate a recurring_account.
  """
  def recurring_account_fixture(attrs \\ %{}) do
    {:ok, recurring_account} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description",
        due_date: ~D[2024-11-01],
        payee: "some payee",
        pix_key: "some pix_key",
        status: "some status"
      })
      |> Bankup.RecurringAccounts.create_recurring_account()

    recurring_account
  end
end
