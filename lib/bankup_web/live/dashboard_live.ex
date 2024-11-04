defmodule BankupWeb.DashboardLive do
  use BankupWeb, :live_view
  alias Bankup.Clients
  alias Bankup.RecurringAccounts
  alias Bankup.Payments
  alias Bankup.Notifications

  def mount(_params, _session, socket) do
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
    <div class="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <h1 class="text-3xl font-semibold text-zinc-900 mb-6">Dashboard</h1>
      <!-- Grid Responsiva com Duas Colunas -->
      <div class="grid grid-cols-1 gap-8 md:grid-cols-2">
        <!-- Clientes -->
        <section class="bg-white shadow rounded-lg p-6">
          <h2 class="text-xl font-semibold text-zinc-800 mb-4">Clientes</h2>
          <ul class="space-y-4">
            <%= for client <- @clients do %>
              <li class="flex items-center justify-between p-4 bg-zinc-50 rounded-lg">
                <span class="text-lg font-medium text-zinc-700"><%= client.full_name %></span>
              </li>
            <% end %>
          </ul>
        </section>
        <!-- Contas Recorrentes -->
        <section class="bg-white shadow rounded-lg p-6">
          <h2 class="text-xl font-semibold text-zinc-800 mb-4">Contas Recorrentes</h2>
          <ul class="space-y-4">
            <%= for account <- @accounts do %>
              <li class="flex flex-col p-4 bg-zinc-50 rounded-lg">
                <span class="text-lg font-medium text-zinc-700"><%= account.description %></span>
                <div class="flex items-center justify-between mt-2 text-sm text-zinc-600">
                  <span>Valor: R$ <%= account.amount / 100 %></span>
                  <span>Status: <%= account.status %></span>
                </div>
              </li>
            <% end %>
          </ul>
        </section>
        <!-- Pagamentos Recentes -->
        <section class="bg-white shadow rounded-lg p-6">
          <h2 class="text-xl font-semibold text-zinc-800 mb-4">Pagamentos Recentes</h2>
          <ul class="space-y-4">
            <%= for payment <- @payments do %>
              <li class="flex flex-col p-4 bg-zinc-50 rounded-lg">
                <span class="text-lg font-medium text-zinc-700">
                  Conta: <%= payment.description %>
                </span>
                <div class="flex items-center justify-between mt-2 text-sm text-zinc-600">
                  <span>Pago: R$ <%= payment.amount_paid / 100 %></span>
                  <span>Status: <%= payment.payment_status %></span>
                </div>
              </li>
            <% end %>
          </ul>
        </section>
        <!-- Notificações -->
        <section class="bg-white shadow rounded-lg p-6">
          <h2 class="text-xl font-semibold text-zinc-800 mb-4">Notificações</h2>
          <ul class="space-y-4">
            <%= for notification <- @notifications do %>
              <li class="flex flex-col p-4 bg-zinc-50 rounded-lg">
                <span class="text-sm text-zinc-700"><%= notification.content %></span>
                <span class="text-xs mt-2 text-zinc-500">
                  Status: <%= notification.delivery_status %>
                </span>
              </li>
            <% end %>
          </ul>
        </section>
      </div>
    </div>
    """
  end
end
