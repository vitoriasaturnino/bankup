defmodule BankupWeb.PaymentsHistoryLive do
  use BankupWeb, :live_view
  alias Bankup.Payments

  def mount(_params, _session, socket) do
    # Obtém todos os clientes
    clients = Payments.list_clients()

    # Obtém os pagamentos para cada cliente
    payments_by_client =
      clients
      |> Enum.map(fn client ->
        {client.name, Payments.list_payments(client.id)}
      end)
      |> Enum.into(%{})

    {:ok, assign(socket, payments_by_client: payments_by_client)}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <h1 class="text-3xl font-semibold text-green-600 mb-6">Histórico de Pagamentos</h1>
      <!-- Exibe os pagamentos agrupados por cliente -->
      <%= for {client_name, payments} <- @payments_by_client do %>
        <div class="mb-8">
          <h2 class="text-2xl font-semibold text-blue-600 mb-4"><%= client_name %></h2>

          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <%= if payments == [] do %>
              <!-- Exibe mensagem para clientes sem contas pagas -->
              <p class="text-sm text-zinc-600">Sem contas pagas por enquanto</p>
            <% else %>
              <!-- Exibe cartões de pagamentos para clientes com contas pagas -->
              <%= for payment <- payments do %>
                <div class="p-4 bg-white shadow rounded-lg">
                  <h3 class="text-lg font-semibold text-zinc-800"><%= payment.description %></h3>
                  <p class="mt-2 text-sm text-zinc-600">
                    Pago:
                    <span class="text-green-600">R$ <%= format_currency(payment.amount_paid) %></span>
                  </p>
                  <p class="text-sm text-zinc-600">
                    Status: <%= payment.payment_status %>
                  </p>
                  <p class="text-sm text-zinc-600">
                    Multa:
                    <span class="text-red-500">
                      R$ <%= format_currency(payment.penalty_applied) %>
                    </span>
                  </p>
                </div>
              <% end %>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp format_currency(amount) do
    amount
    |> Kernel./(100)
    |> :erlang.float_to_binary(decimals: 2)
  end
end
