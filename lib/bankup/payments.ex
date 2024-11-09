defmodule Bankup.Payments do
  use Ecto.Schema

  import Ecto.Query
  alias Bankup.Clients.Client
  alias Bankup.Payments.Payment
  alias Bankup.RecurringAccounts.RecurringAccount
  alias Bankup.Repo

  # Taxas e configurações
  @penalty_rate 0.02
  @billing_rate 0.001

  # Função nova para listar todos os clientes com os campos id e name
  @doc """
  Lista todos os clientes com os campos `id` e `name`.
  """
  def list_clients do
    from(c in Client, select: %{id: c.id, name: c.full_name})
    |> Repo.all()
  end

  # Funções existentes
  @doc """
  Aplica uma multa automática se a conta estiver em atraso.
  """
  def apply_penalty_if_due(%RecurringAccount{} = account) do
    if Date.utc_today() > account.due_date do
      penalty = calculate_penalty(account.amount)

      %Payment{}
      |> Payment.changeset(%{
        account_id: account.id,
        amount_paid: 0,
        payment_date: nil,
        payment_status: "pendente",
        penalty_applied: penalty
      })
      |> Repo.insert()
    else
      {:ok, "A conta não está vencida."}
    end
  end

  @doc """
  Calcula a multa com base em uma taxa fixa e no valor da conta.
  """
  def calculate_penalty(amount) do
    trunc(amount * @penalty_rate)
  end

  @doc """
  Lista todos os pagamentos de um cliente, incluindo detalhes da conta e multa aplicada.
  """
  def list_payments(client_id) do
    from(p in Payment,
      join: r in assoc(p, :recurring_account),
      where: r.client_id == ^client_id,
      select: %{
        payment_id: p.id,
        description: r.description,
        amount: r.amount,
        amount_paid: p.amount_paid,
        payment_date: p.payment_date,
        payment_status: p.payment_status,
        penalty_applied: p.penalty_applied,
        due_date: r.due_date,
        payee: r.payee,
        status: r.status
      },
      order_by: [desc: p.payment_date]
    )
    |> Repo.all()
  end

  @doc """
  Calcula o faturamento mensal de um cliente com base no total movimentado.
  """
  def calculate_monthly_billing(client_id) do
    total_moved =
      from(p in Payment,
        where:
          p.client_id == ^client_id and p.payment_status == "concluído" and
            fragment("date_part('month', ?) = date_part('month', current_date)", p.payment_date),
        select: sum(p.amount_paid)
      )
      |> Repo.one()
      |> Kernel.||(0)

    billing_amount = trunc(total_moved * @billing_rate)
    client = Repo.get(Client, client_id)
    new_accumulated_balance = client.accumulated_balance + billing_amount

    if new_accumulated_balance >= 100 do
      Repo.update_all(
        from(c in Client, where: c.id == ^client_id),
        set: [accumulated_balance: 0, pending_billing: new_accumulated_balance]
      )

      {:ok, "Cobrança pendente gerada de #{new_accumulated_balance} centavos"}
    else
      Repo.update_all(
        from(c in Client, where: c.id == ^client_id),
        set: [accumulated_balance: new_accumulated_balance]
      )

      {:ok, "Saldo acumulado atualizado para #{new_accumulated_balance} centavos"}
    end
  end

  def create_payment(attrs) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  def list_all_payments() do
    from(p in Payment,
      join: r in assoc(p, :recurring_account),
      select: %{
        payment_id: p.id,
        description: r.description,
        amount: r.amount,
        amount_paid: p.amount_paid,
        payment_date: p.payment_date,
        payment_status: p.payment_status,
        penalty_applied: p.penalty_applied,
        due_date: r.due_date,
        payee: r.payee,
        status: r.status
      },
      order_by: [desc: p.payment_date]
    )
    |> Repo.all()
  end
end
