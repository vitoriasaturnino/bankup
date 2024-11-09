defmodule BankupWeb.RecurringAccountsLive do
  use BankupWeb, :live_view
  alias Bankup.RecurringAccounts
  alias Bankup.RecurringAccounts.RecurringAccount
  alias Bankup.Payments
  import Ecto.Changeset, only: [get_field: 2]

  def mount(_params, _session, socket) do
    accounts = RecurringAccounts.list_accounts()
    changeset = RecurringAccount.changeset(%RecurringAccount{})

    {:ok,
     assign(socket,
       accounts: accounts,
       changeset: changeset
     )}
  end

  def handle_event("save", %{"recurring_account" => account_params}, socket) do
    case RecurringAccounts.create_recurring_account(account_params) do
      {:ok, _account} ->
        accounts = RecurringAccounts.list_accounts()

        {:noreply,
         assign(socket,
           accounts: accounts,
           changeset: RecurringAccount.changeset(%RecurringAccount{})
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  # Evento para registrar o pagamento de uma conta
  def handle_event("mark_as_paid", %{"account_id" => account_id}, socket) do
    case Payments.create_payment(%{
           amount_paid: RecurringAccounts.get_account_amount(account_id),
           payment_date: DateTime.utc_now(),
           payment_status: "concluído",
           penalty_applied: 0,
           recurring_account_id: account_id
         }) do
      {:ok, _payment} ->
        accounts = RecurringAccounts.list_accounts()
        {:noreply, assign(socket, accounts: accounts)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Failed to mark as paid: #{reason}")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-6xl px-10 py-12 bg-gradient-to-b from-white to-gray-100 shadow-2xl rounded-3xl">
      <h1 class="text-4xl font-semibold text-green-600 mb-10 tracking-tight">Contas Recorrentes</h1>
      <!-- Formulário de Criação de Conta Recorrente -->
      <form phx-submit="save" class="bg-white shadow-lg rounded-2xl p-8 mb-12 space-y-6">
        <h2 class="text-2xl font-semibold text-zinc-900 mb-6">Nova Conta Recorrente</h2>
        <div class="space-y-6">
          <div>
            <label for="description" class="block text-lg font-medium text-zinc-700">Descrição</label>
            <input
              type="text"
              name="recurring_account[description]"
              value={get_field(@changeset, :description)}
              class="mt-2 block w-full rounded-lg border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
            />
            <%= error_tag(@changeset, :description, assigns) %>
          </div>

          <div>
            <label for="amount" class="block text-lg font-medium text-zinc-700">
              Valor (em centavos)
            </label>
            <input
              type="number"
              name="recurring_account[amount]"
              value={get_field(@changeset, :amount)}
              class="mt-2 block w-full rounded-lg border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
            />
            <%= error_tag(@changeset, :amount, assigns) %>
          </div>

          <div>
            <label for="due_date" class="block text-lg font-medium text-zinc-700">
              Data de Vencimento
            </label>
            <input
              type="date"
              name="recurring_account[due_date]"
              value={get_field(@changeset, :due_date)}
              class="mt-2 block w-full rounded-lg border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
            />
            <%= error_tag(@changeset, :due_date, assigns) %>
          </div>

          <div>
            <label for="payee" class="block text-lg font-medium text-zinc-700">Beneficiário</label>
            <input
              type="text"
              name="recurring_account[payee]"
              value={get_field(@changeset, :payee)}
              class="mt-2 block w-full rounded-lg border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
            />
            <%= error_tag(@changeset, :payee, assigns) %>
          </div>

          <div>
            <label for="pix_key" class="block text-lg font-medium text-zinc-700">Chave PIX</label>
            <input
              type="text"
              name="recurring_account[pix_key]"
              value={get_field(@changeset, :pix_key)}
              class="mt-2 block w-full rounded-lg border border-zinc-300 shadow-sm focus:border-green-600 focus:ring focus:ring-green-200"
            />
            <%= error_tag(@changeset, :pix_key, assigns) %>
          </div>
        </div>
        <button
          type="submit"
          class="w-full py-3 mt-6 bg-green-600 text-white text-lg font-medium rounded-lg shadow hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
        >
          Criar Conta Recorrente
        </button>
      </form>
      <!-- Lista de Contas Recorrentes -->
      <div class="grid grid-cols-1 gap-10 md:grid-cols-2 lg:grid-cols-3">
        <%= for account <- @accounts do %>
          <div class="p-6 bg-white shadow-lg rounded-xl transition-transform transform hover:scale-105 hover:shadow-2xl">
            <h3 class="text-2xl font-medium text-zinc-800 mb-4"><%= account.description %></h3>
            <p class="text-lg text-zinc-600">
              Valor:
              <span class="text-green-600 font-semibold">
                R$ <%= format_currency(account.amount / 100) %>
              </span>
            </p>
            <p class="text-md text-zinc-600">Vencimento: <%= account.due_date %></p>
            <!-- Verifica se há algum pagamento concluído para esta conta -->
            <div class="mt-6">
              <%= case Enum.find(account.payments, &(&1.payment_status == "concluído")) do %>
                <% nil -> %>
                  <button
                    phx-click="mark_as_paid"
                    phx-value-account_id={account.id}
                    class="w-full py-2 bg-green-500 text-white font-medium rounded-lg transition-colors hover:bg-green-600"
                  >
                    Marcar como Pago
                  </button>
                <% last_payment -> %>
                  <span class="text-green-700 font-semibold">
                    Pago em <%= format_date(last_payment.payment_date) %>
                  </span>
              <% end %>
            </div>
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

  defp format_date(date) do
    Calendar.strftime(date, "%d/%m/%Y")
  end
end
