defmodule BankupWeb.RecurringAccountsLive do
  use BankupWeb, :live_view
  alias Bankup.RecurringAccounts

  def mount(_params, _session, socket) do
    # Substituir pelo ID do cliente autenticado em um sistema real
    client_id = 1
    accounts = RecurringAccounts.list_accounts(client_id)
    {:ok, assign(socket, accounts: accounts)}
  end

  def render(assigns) do
    ~H"""
    <h1>Contas Recorrentes</h1>
    <ul>
      <%= for account <- @accounts do %>
        <li>
          <%= account.description %>: R$ <%= account.amount / 100 %> - Vencimento: <%= account.due_date %> - Status: <%= account.status %>
        </li>
      <% end %>
    </ul>
    """
  end
end
