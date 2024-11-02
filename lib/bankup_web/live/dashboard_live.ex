defmodule BankupWeb.DashboardLive do
  use BankupWeb, :live_view
  alias Bankup.RecurringAccounts
  alias Bankup.Payments
  alias Bankup.Notifications

  def mount(_params, _session, socket) do
    # Substituir pelo ID do cliente autenticado em um sistema real
    client_id = 1
    accounts = RecurringAccounts.list_accounts(client_id)
    payments = Payments.list_payments(client_id)
    notifications = Notifications.list_notifications(client_id)

    {:ok, assign(socket, accounts: accounts, payments: payments, notifications: notifications)}
  end

  def render(assigns) do
    ~H"""
    <h1>Dashboard</h1>

    <section>
      <h2>Contas Recorrentes</h2>
      <ul>
        <%= for account <- @accounts do %>
          <li>
            <%= account.description %>: R$ <%= account.amount / 100 %> - Status: <%= account.status %>
          </li>
        <% end %>
      </ul>
    </section>

    <section>
      <h2>Pagamentos Recentes</h2>
      <ul>
        <%= for payment <- @payments do %>
          <li>
            <%= payment.description %> - Pago: R$ <%= payment.amount_paid / 100 %> - Status: <%= payment.payment_status %>
          </li>
        <% end %>
      </ul>
    </section>

    <section>
      <h2>Notificações</h2>
      <ul>
        <%= for notification <- @notifications do %>
          <li><%= notification.content %> - Status: <%= notification.delivery_status %></li>
        <% end %>
      </ul>
    </section>
    """
  end
end
