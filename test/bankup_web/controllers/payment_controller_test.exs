defmodule BankupWeb.PaymentControllerTest do
  use BankupWeb.ConnCase

  import Mox
  setup :verify_on_exit!

  alias Bankup.Payments
  alias Bankup.Payments.Payment

  @valid_attrs %{
    amount_paid: 1000.50,
    payment_date: ~U[2024-01-01 12:00:00Z],
    payment_method: "PIX",
    payment_status: "concluído",
    penalty_applied: 10.50
  }
  @invalid_attrs %{}

  setup [:create_recurring_account]

  describe "index/2" do
    test "lists all payments", %{conn: conn} do
      conn = get(conn, ~p"/api/payments")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create/2" do
    test "creates and renders payment when data is valid", %{
      conn: conn,
      recurring_account: account
    } do
      conn =
        post(conn, ~p"/api/payments", payment: Map.put(@valid_attrs, :account_id, account.id))

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/payments/#{id}")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "does not create payment and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/payments", payment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "creates payment and sends notifications", %{conn: conn, recurring_account: account} do
      expect(EmailNotifierMock, :send_payment_notification, fn _email, _payment -> :ok end)
      expect(WhatsAppNotifierMock, :send_whatsapp_message, fn _phone, _message -> :ok end)

      conn =
        post(conn, ~p"/api/payments", payment: Map.put(@valid_attrs, :account_id, account.id))

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/payments/#{id}")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end
  end

  describe "update/2" do
    setup [:create_payment]

    test "updates and renders payment when data is valid", %{conn: conn, payment: payment} do
      payment_id = payment.id

      conn =
        put(conn, ~p"/api/payments/#{payment_id}",
          payment: %{@valid_attrs | payment_status: "pendente"}
        )

      response = json_response(conn, 200)["data"]
      assert %{"id" => ^payment_id, "payment_status" => "pendente"} = response
    end

    test "does not update payment and renders errors when data is invalid", %{
      conn: conn,
      payment: payment
    } do
      conn = put(conn, ~p"/api/payments/#{payment.id}", payment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete(conn, ~p"/api/payments/#{payment.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/payments/#{payment.id}")
      end
    end
  end

  defp create_recurring_account(_) do
    {:ok, account} =
      Bankup.RecurringAccounts.create_recurring_account(%{
        description: "Aluguel",
        amount: 1000.50,
        due_date: ~D[2024-01-01],
        payee: "João da Silva",
        pix_key: "chave-pix",
        status: "ativa"
      })

    %{recurring_account: account}
  end

  defp create_payment(_) do
    {:ok, payment} = Payments.create_payment(@valid_attrs)
    %{payment: payment}
  end
end
