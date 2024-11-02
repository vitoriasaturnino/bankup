defmodule Bankup.PaymentsTest do
  use Bankup.DataCase

  alias Bankup.Payments

  describe "payments" do
    alias Bankup.Payments.Payment

    import Bankup.PaymentsFixtures

    @invalid_attrs %{
      amount_paid: nil,
      payment_date: nil,
      payment_method: nil,
      payment_status: nil,
      penalty_applied: nil
    }

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Payments.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Payments.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      valid_attrs = %{
        amount_paid: 42,
        payment_date: ~U[2024-11-01 18:17:00Z],
        payment_method: "some payment_method",
        payment_status: "some payment_status",
        penalty_applied: 42
      }

      assert {:ok, %Payment{} = payment} = Payments.create_payment(valid_attrs)
      assert payment.amount_paid == 42
      assert payment.payment_date == ~U[2024-11-01 18:17:00Z]
      assert payment.payment_method == "some payment_method"
      assert payment.payment_status == "some payment_status"
      assert payment.penalty_applied == 42
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()

      update_attrs = %{
        amount_paid: 43,
        payment_date: ~U[2024-11-02 18:17:00Z],
        payment_method: "some updated payment_method",
        payment_status: "some updated payment_status",
        penalty_applied: 43
      }

      assert {:ok, %Payment{} = payment} = Payments.update_payment(payment, update_attrs)
      assert payment.amount_paid == 43
      assert payment.payment_date == ~U[2024-11-02 18:17:00Z]
      assert payment.payment_method == "some updated payment_method"
      assert payment.payment_status == "some updated payment_status"
      assert payment.penalty_applied == 43
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment(payment, @invalid_attrs)
      assert payment == Payments.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment(payment)
    end
  end
end
