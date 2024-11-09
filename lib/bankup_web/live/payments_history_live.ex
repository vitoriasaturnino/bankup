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
    <div class="mx-auto max-w-6xl px-10 py-12 bg-gradient-to-b from-white to-gray-100 shadow-2xl rounded-3xl">
      <h1 class="text-4xl font-semibold text-green-600 mb-10 tracking-tight">
        Histórico de Pagamentos
      </h1>
      <!-- Pagamentos Agrupados por Cliente -->
      <%= for {client_name, payments} <- @payments_by_client do %>
        <div class="mb-12">
          <h2 class="text-3xl font-semibold text-zinc-900 mb-6 tracking-tight"><%= client_name %></h2>

          <div class="grid grid-cols-1 gap-8 md:grid-cols-2 lg:grid-cols-3">
            <%= if payments == [] do %>
              <!-- Mensagem para Clientes sem Contas Pagas -->
              <p class="text-lg text-zinc-500 italic">Sem contas pagas por enquanto</p>
            <% else %>
              <!-- Cartões de Pagamentos -->
              <%= for payment <- payments do %>
                <div class="p-6 bg-white shadow-xl rounded-lg transition-transform transform hover:scale-105 hover:shadow-2xl">
                  <h3 class="text-2xl font-medium text-zinc-800 mb-4"><%= payment.description %></h3>
                  <p class="text-md text-zinc-600 mb-1">
                    Pago:
                    <span class="text-green-600 font-semibold">
                      R$ <%= format_currency(payment.amount_paid) %>
                    </span>
                  </p>
                  <p class="text-md text-zinc-600 mb-1">
                    Status: <span class="font-medium"><%= payment.payment_status %></span>
                  </p>
                  <p class="text-md text-zinc-600">
                    Multa:
                    <span class="text-red-500 font-semibold">
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
