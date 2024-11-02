defmodule Bankup.Payments do
  use Ecto.Schema

  import Ecto.Query

  alias Bankup.Repo
  alias Bankup.Payments.Payment
  alias Bankup.RecurringAccounts.RecurringAccount

  # Exemplo de taxa de multa: 2% do valor da conta
  @penalty_rate 0.02

  @doc """
  Aplica uma multa automática se a conta estiver em atraso.
  """
  def apply_penalty_if_due(%RecurringAccount{} = account) do
    # Verifica se a conta está em atraso
    if Date.utc_today() > account.due_date do
      penalty = calculate_penalty(account.amount)

      # Cria o pagamento com a multa aplicada
      %Payment{}
      |> Payment.changeset(%{
        account_id: account.id,
        # Não pago ainda
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
    # Calcula a multa com base na taxa fixa
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
end
