defmodule BankupWeb.RecurringAccountsLive do
  use BankupWeb, :live_view
  alias Bankup.RecurringAccounts
  alias Bankup.RecurringAccounts.RecurringAccount
  import Ecto.Changeset, only: [get_field: 2]

  def mount(_params, _session, socket) do
    # Simulação de cliente autenticado
    client_id = "300401f4-0f42-4f25-b6ed-fb69464d2cd3"
    accounts = RecurringAccounts.list_accounts(client_id)

    changeset = RecurringAccount.changeset(%RecurringAccount{})

    {:ok,
     assign(socket,
       accounts: accounts,
       changeset: changeset,
       client_id: client_id
     )}
  end

  def handle_event("save", %{"recurring_account" => account_params}, socket) do
    account_params = Map.put(account_params, "client_id", socket.assigns.client_id)

    case RecurringAccounts.create_recurring_account(account_params) do
      {:ok, _account} ->
        accounts = RecurringAccounts.list_accounts(socket.assigns.client_id)

        {:noreply,
         assign(socket,
           accounts: accounts,
           changeset: RecurringAccount.changeset(%RecurringAccount{})
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <h1>Contas Recorrentes</h1>

    <form phx-submit="save">
      <div>
        <label for="description">Descrição</label>
        <input
          type="text"
          name="recurring_account[description]"
          value={get_field(@changeset, :description)}
        />
        <%= error_tag(@changeset, :description, assigns) %>
      </div>

      <div>
        <label for="amount">Valor (em centavos)</label>
        <input type="number" name="recurring_account[amount]" value={get_field(@changeset, :amount)} />
        <%= error_tag(@changeset, :amount, assigns) %>
      </div>

      <div>
        <label for="due_date">Data de Vencimento</label>
        <input
          type="date"
          name="recurring_account[due_date]"
          value={get_field(@changeset, :due_date)}
        />
        <%= error_tag(@changeset, :due_date, assigns) %>
      </div>

      <div>
        <label for="payee">Beneficiário</label>
        <input type="text" name="recurring_account[payee]" value={get_field(@changeset, :payee)} />
        <%= error_tag(@changeset, :payee, assigns) %>
      </div>

      <div>
        <label for="pix_key">Chave PIX</label>
        <input type="text" name="recurring_account[pix_key]" value={get_field(@changeset, :pix_key)} />
        <%= error_tag(@changeset, :pix_key, assigns) %>
      </div>

      <div>
        <button type="submit">Criar Conta Recorrente</button>
      </div>
    </form>

    <ul>
      <%= for account <- @accounts do %>
        <li>
          <%= account.description %>: R$ <%= account.amount / 100 %> - Vencimento: <%= account.due_date %> - Status: <%= account.status %>
        </li>
      <% end %>
    </ul>
    """
  end

  defp error_tag(changeset, field, assigns) do
    if error = Keyword.get(changeset.errors, field) do
      assigns = Map.put(assigns, :error, elem(error, 0))

      ~H"""
      <span class="error"><%= @error %></span>
      """
    end
  end
end
