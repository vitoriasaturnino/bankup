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
    <div class="mx-auto max-w-7xl px-8 py-12">
      <h1 class="text-5xl font-semibold text-zinc-900 mb-12 tracking-tight">Dashboard</h1>
      <!-- Grid Responsiva com Duas Colunas, Espaçamento Ampliado -->
      <div class="grid grid-cols-1 gap-12 lg:grid-cols-2">
        <!-- Clientes -->
        <section class="bg-white shadow-lg rounded-2xl p-8 transition-transform duration-200 hover:scale-105 bg-gradient-to-br from-green-100 to-green-200">
          <h2 class="text-2xl font-semibold text-zinc-900 mb-6">Clientes</h2>
          <ul class="space-y-6">
            <%= for client <- @clients do %>
              <li class="flex items-center justify-between p-5 bg-white/80 rounded-lg shadow-md backdrop-blur-md transition duration-200 hover:bg-green-50">
                <span class="text-xl font-medium text-zinc-800"><%= client.full_name %></span>
              </li>
            <% end %>
          </ul>
        </section>
        <!-- Contas Recorrentes -->
        <section class="bg-white shadow-lg rounded-2xl p-8 transition-transform duration-200 hover:scale-105 bg-gradient-to-br from-green-100 to-green-200">
          <h2 class="text-2xl font-semibold text-zinc-900 mb-6">Contas Recorrentes</h2>
          <ul class="space-y-6">
            <%= for account <- @accounts do %>
              <li class="flex flex-col p-5 bg-white/80 rounded-lg shadow-md backdrop-blur-md transition duration-200 hover:bg-green-50">
                <span class="text-xl font-medium text-zinc-800"><%= account.description %></span>
                <div class="flex items-center justify-between mt-3 text-md text-zinc-700">
                  <span>Valor: R$ <%= account.amount / 100 %></span>
                  <span>Status: <%= account.status %></span>
                </div>
              </li>
            <% end %>
          </ul>
        </section>
        <!-- Pagamentos Recentes -->
        <section class="bg-white shadow-lg rounded-2xl p-8 transition-transform duration-200 hover:scale-105 bg-gradient-to-br from-green-100 to-green-200">
          <h2 class="text-2xl font-semibold text-zinc-900 mb-6">Pagamentos Recentes</h2>
          <ul class="space-y-6">
            <%= for payment <- @payments do %>
              <li class="flex flex-col p-5 bg-white/80 rounded-lg shadow-md backdrop-blur-md transition duration-200 hover:bg-green-50">
                <span class="text-xl font-medium text-zinc-800">
                  Conta: <%= payment.description %>
                </span>
                <div class="flex items-center justify-between mt-3 text-md text-zinc-700">
                  <span>Pago: R$ <%= payment.amount_paid / 100 %></span>
                  <span>Status: <%= payment.payment_status %></span>
                </div>
              </li>
            <% end %>
          </ul>
        </section>
        <!-- Notificações -->
        <section class="bg-white shadow-lg rounded-2xl p-8 transition-transform duration-200 hover:scale-105 bg-gradient-to-br from-green-100 to-green-200">
          <h2 class="text-2xl font-semibold text-zinc-900 mb-6">Notificações</h2>
          <ul class="space-y-6">
            <%= for notification <- @notifications do %>
              <li class="flex flex-col p-5 bg-white/80 rounded-lg shadow-md backdrop-blur-md transition duration-200 hover:bg-green-50">
                <span class="text-md text-zinc-800"><%= notification.content %></span>
                <span class="text-sm mt-3 text-zinc-600">
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
