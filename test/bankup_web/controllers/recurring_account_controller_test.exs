defmodule BankupWeb.RecurringAccountControllerTest do
  use BankupWeb.ConnCase

  import Mox
  setup :verify_on_exit!

  alias Bankup.RecurringAccounts
  alias Bankup.RecurringAccounts.RecurringAccount

  @valid_attrs %{
    description: "Aluguel",
    amount: 1000.50,
    due_date: ~D[2024-01-01],
    payee: "João da Silva",
    pix_key: "chave-pix",
    status: "ativa"
  }
  @invalid_attrs %{}

  setup [:create_client]

  describe "index/2" do
    test "lists all recurring accounts", %{conn: conn} do
      conn = get(conn, ~p"/api/recurring_accounts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create/2" do
    test "creates and renders recurring account when data is valid", %{conn: conn, client: client} do
      conn =
        post(conn, ~p"/api/recurring_accounts",
          recurring_account: Map.put(@valid_attrs, :client_id, client.id)
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/recurring_accounts/#{id}")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "does not create recurring account and renders errors when data is invalid", %{
      conn: conn
    } do
      conn = post(conn, ~p"/api/recurring_accounts", recurring_account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "creates recurring account and sends notifications", %{conn: conn, client: client} do
      expect(EmailNotifierMock, :send_payment_notification, fn _email, _account -> :ok end)
      expect(WhatsAppNotifierMock, :send_whatsapp_message, fn _phone, _message -> :ok end)

      conn =
        post(conn, ~p"/api/recurring_accounts",
          recurring_account: Map.put(@valid_attrs, :client_id, client.id)
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/recurring_accounts/#{id}")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end
  end

  describe "update/2" do
    setup [:create_recurring_account]

    test "updates and renders recurring account when data is valid", %{
      conn: conn,
      recurring_account: account
    } do
      account_id = account.id

      conn =
        put(conn, ~p"/api/recurring_accounts/#{account_id}",
          recurring_account: %{@valid_attrs | description: "Luz"}
        )

      response = json_response(conn, 200)["data"]
      assert %{"id" => ^account_id, "description" => "Luz"} = response
    end

    test "does not update recurring account and renders errors when data is invalid", %{
      conn: conn,
      recurring_account: account
    } do
      conn =
        put(conn, ~p"/api/recurring_accounts/#{account.id}", recurring_account: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup [:create_recurring_account]

    test "deletes chosen recurring account", %{conn: conn, recurring_account: account} do
      conn = delete(conn, ~p"/api/recurring_accounts/#{account.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/recurring_accounts/#{account.id}")
      end
    end
  end

  defp create_client(_) do
    {:ok, client} =
      Bankup.Clients.create_client(%{
        full_name: "John Doe",
        cpf_cnpj: "12345678900",
        email: "john@example.com",
        phone: "123456789",
        whatsapp: "123456789",
        country: "Brazil",
        state: "SP",
        city: "Sao Paulo",
        postal_code: "12345-678",
        street_address: "123 Elm Street",
        birth_date: ~D[1990-01-01]
      })

    %{client: client}
  end

  defp create_recurring_account(_) do
    {:ok, account} = RecurringAccounts.create_recurring_account(@valid_attrs)
    %{recurring_account: account}
  end
end
