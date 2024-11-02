defmodule BankupWeb.PaymentsHistoryLive do
  use BankupWeb, :live_view
  alias Bankup.Payments

  def mount(_params, _session, socket) do
    # Substituir pelo ID do cliente autenticado em um sistema real
    client_id = 1
    payments = Payments.list_payments(client_id)
    {:ok, assign(socket, payments: payments)}
  end

  def render(assigns) do
    ~H"""
    <h1>Histórico de Pagamentos</h1>
    <ul>
      <%= for payment <- @payments do %>
        <li>
          <%= payment.description %>: Pago: R$ <%= payment.amount_paid / 100 %> - Status: <%= payment.payment_status %> - Multa: R$ <%= payment.penalty_applied /
            100 %>
        </li>
      <% end %>
    </ul>
    """
  end
end
