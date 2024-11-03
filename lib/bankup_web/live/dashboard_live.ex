defmodule BankupWeb.DashboardLive do
  use BankupWeb, :live_view
  alias Bankup.Clients
  alias Bankup.RecurringAccounts
  alias Bankup.Payments
  alias Bankup.Notifications

  # Monta o Dashboard sem autenticação
  def mount(_params, _session, socket) do
    # Usar dados de um client_id fixo para simplificação
    # Substitua com um ID válido para teste
    client_id = "300401f4-0f42-4f25-b6ed-fb69464d2cd3"

    clients = Clients.list_clients(client_id)
    accounts = RecurringAccounts.list_accounts(client_id)
    payments = Payments.list_payments(client_id)
    notifications = Notifications.list_notifications(client_id)

    {:ok,
     assign(socket,
       clients: clients,
       accounts: accounts,
       payments: payments,
       notifications: notifications
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Dashboard</h1>

    <section>
      <h2>Clientes</h2>
      <ul>
        <%= for client <- @clients do %>
          <li><%= client.full_name %></li>
        <% end %>
      </ul>
    </section>

    <section>
      <h2>Contas Recorrentes</h2>
      <ul>
        <%= for account <- @accounts do %>
          <li>
            <strong><%= account.description %></strong>: R$ <%= account.amount / 100 %> - Status: <%= account.status %>
          </li>
        <% end %>
      </ul>
    </section>

    <section>
      <h2>Pagamentos Recentes</h2>
      <ul>
        <%= for payment <- @payments do %>
          <li>
            Conta: <%= payment.description %> - Pago: R$ <%= payment.amount_paid / 100 %> - Status: <%= payment.payment_status %>
          </li>
        <% end %>
      </ul>
    </section>

    <section>
      <h2>Notificações</h2>
      <ul>
        <%= for notification <- @notifications do %>
          <li>
            <%= notification.content %> - Status: <%= notification.delivery_status %>
          </li>
        <% end %>
      </ul>
    </section>
    """
  end
end
