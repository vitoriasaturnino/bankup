defmodule BankupWeb.RecurringAccountController do
  use BankupWeb, :controller

  alias Bankup.RecurringAccounts
  alias Bankup.RecurringAccounts.RecurringAccount
  alias Bankup.Notifications.{EmailNotifier, WhatsAppNotifier}

  action_fallback BankupWeb.FallbackController

  def index(conn, _params) do
    accounts = RecurringAccounts.list_recurring_accounts()
    json(conn, %{data: accounts})
  end

  def create(conn, %{"recurring_account" => account_params}) do
    with {:ok, %RecurringAccount{} = account} <-
           RecurringAccounts.create_recurring_account(account_params),
         # Carregar a associação client
         account <- Bankup.Repo.preload(account, :client) do
      client = account.client

      EmailNotifier.send_payment_notification(client.email, account)

      WhatsAppNotifier.send_whatsapp_message(
        client.whatsapp,
        "Recurring account created: #{account.description}"
      )

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/recurring_accounts/#{account.id}")
      |> json(%{data: account})
    end
  end

  def show(conn, %{"id" => id}) do
    account = RecurringAccounts.get_recurring_account!(id)
    json(conn, %{data: account})
  end

  def update(conn, %{"id" => id, "recurring_account" => account_params}) do
    account = RecurringAccounts.get_recurring_account!(id)

    with {:ok, %RecurringAccount{} = account} <-
           RecurringAccounts.update_recurring_account(account, account_params) do
      json(conn, %{data: account})
    end
  end

  def delete(conn, %{"id" => id}) do
    account = RecurringAccounts.get_recurring_account!(id)

    with {:ok, %RecurringAccount{}} <- RecurringAccounts.delete_recurring_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
