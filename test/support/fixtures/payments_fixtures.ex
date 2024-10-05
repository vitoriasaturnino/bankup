defmodule Bankup.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankup.Payments` context.
  """

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} =
      attrs
      |> Enum.into(%{
        amount_paid: "120.5",
        payment_date: ~U[2024-10-04 19:25:00Z],
        payment_method: "some payment_method",
        payment_status: "some payment_status",
        penalty_applied: "120.5"
      })
      |> Bankup.Payments.create_payment()

    payment
  end
end
