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
    <div class="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <h1 class="text-3xl font-semibold text-green-600 mb-6">Contas Recorrentes</h1>
      <!-- Formulário de Criação de Conta Recorrente -->
      <form phx-submit="save" class="bg-white shadow rounded-lg p-6 mb-8 space-y-6">
        <div>
          <label for="description" class="block text-sm font-medium text-zinc-700">Descrição</label>
          <input
            type="text"
            name="recurring_account[description]"
            value={get_field(@changeset, :description)}
            class="mt-1 block w-full rounded-md border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
          />
          <%= error_tag(@changeset, :description, assigns) %>
        </div>

        <div>
          <label for="amount" class="block text-sm font-medium text-zinc-700">
            Valor (em centavos)
          </label>
          <input
            type="number"
            name="recurring_account[amount]"
            value={get_field(@changeset, :amount)}
            class="mt-1 block w-full rounded-md border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
          />
          <%= error_tag(@changeset, :amount, assigns) %>
        </div>

        <div>
          <label for="due_date" class="block text-sm font-medium text-zinc-700">
            Data de Vencimento
          </label>
          <input
            type="date"
            name="recurring_account[due_date]"
            value={get_field(@changeset, :due_date)}
            class="mt-1 block w-full rounded-md border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
          />
          <%= error_tag(@changeset, :due_date, assigns) %>
        </div>

        <div>
          <label for="payee" class="block text-sm font-medium text-zinc-700">Beneficiário</label>
          <input
            type="text"
            name="recurring_account[payee]"
            value={get_field(@changeset, :payee)}
            class="mt-1 block w-full rounded-md border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
          />
          <%= error_tag(@changeset, :payee, assigns) %>
        </div>

        <div>
          <label for="pix_key" class="block text-sm font-medium text-zinc-700">Chave PIX</label>
          <input
            type="text"
            name="recurring_account[pix_key]"
            value={get_field(@changeset, :pix_key)}
            class="mt-1 block w-full rounded-md border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
          />
          <%= error_tag(@changeset, :pix_key, assigns) %>
        </div>

        <div>
          <button
            type="submit"
            class="w-full py-2 px-4 bg-green-600 text-white font-medium rounded-md shadow hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
          >
            Criar Conta Recorrente
          </button>
        </div>
      </form>
      <!-- Lista de Contas Recorrentes -->
      <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
        <%= for account <- @accounts do %>
          <div class="p-4 bg-white shadow rounded-lg">
            <h3 class="text-lg font-semibold text-zinc-800"><%= account.description %></h3>
            <p class="mt-2 text-sm text-zinc-600">
              Valor: <span class="text-green-600">R$ <%= format_currency(account.amount / 100) %></span>
            </p>
            <p class="text-sm text-zinc-600">Vencimento: <%= account.due_date %></p>
            <p class="text-sm text-zinc-600">Status: <%= account.status %></p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp error_tag(changeset, field, assigns) do
    if error = Keyword.get(changeset.errors, field) do
      assigns = Map.put(assigns, :error, elem(error, 0))

      ~H"""
      <span class="text-red-500 text-sm"><%= @error %></span>
      """
    end
  end

  defp format_currency(amount) do
    amount
    |> Kernel./(100)
    |> :erlang.float_to_binary(decimals: 2)
  end
end
