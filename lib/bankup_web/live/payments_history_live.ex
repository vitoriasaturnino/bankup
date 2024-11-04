defmodule BankupWeb.PaymentsHistoryLive do
  use BankupWeb, :live_view
  alias Bankup.Payments

  def mount(_params, _session, socket) do
    # Substituir pelo ID do cliente autenticado em um sistema real
    client_id = "300401f4-0f42-4f25-b6ed-fb69464d2cd3"
    payments = Payments.list_payments(client_id)
    {:ok, assign(socket, payments: payments)}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <h1 class="text-3xl font-semibold text-green-600 mb-6">Histórico de Pagamentos</h1>
      <!-- Lista de Pagamentos em Formato de Cartão -->
      <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
        <%= for payment <- @payments do %>
          <div class="p-4 bg-white shadow rounded-lg">
            <h3 class="text-lg font-semibold text-zinc-800"><%= payment.description %></h3>
            <p class="mt-2 text-sm text-zinc-600">
              Pago: <span class="text-green-600">R$ <%= format_currency(payment.amount_paid) %></span>
            </p>
            <p class="text-sm text-zinc-600">
              Status: <%= payment.payment_status %>
            </p>
            <p class="text-sm text-zinc-600">
              Multa:
              <span class="text-red-500">R$ <%= format_currency(payment.penalty_applied) %></span>
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp format_currency(amount) do
    amount
    |> Kernel./(100)
    |> :erlang.float_to_binary(decimals: 2)
  end
end
