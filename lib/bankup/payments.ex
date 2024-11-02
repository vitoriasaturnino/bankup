defmodule Bankup.Payments do
  use Ecto.Schema

  import Ecto.Query

  alias Bankup.Clients.Client
  alias Bankup.Payments.Payment
  alias Bankup.RecurringAccounts.RecurringAccount
  alias Bankup.Repo

  # Exemplo de taxa de multa: 2% do valor da conta
  @penalty_rate 0.02
  # Taxa de faturamento de 0,1%
  @billing_rate 0.001

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

  @doc """
  Calcula o faturamento mensal de um cliente com base no total movimentado
  e acumula até atingir o mínimo de R$ 1,00.
  """
  def calculate_monthly_billing(client_id) do
    # Calcula o total movimentado pelo cliente no mês corrente
    total_moved =
      from(p in Payment,
        where:
          p.client_id == ^client_id and p.payment_status == "concluído" and
            fragment("date_part('month', ?) = date_part('month', current_date)", p.payment_date),
        select: sum(p.amount_paid)
      )
      |> Repo.one()
      |> Kernel.||(0)

    # Calcula o valor do faturamento com a taxa
    billing_amount = trunc(total_moved * @billing_rate)

    # Busca o cliente e suas configurações para verificar o saldo pendente
    client = Repo.get(Client, client_id)

    # Atualiza o saldo acumulado
    new_accumulated_balance = client.accumulated_balance + billing_amount

    if new_accumulated_balance >= 100 do
      # Marca o faturamento como pendente para pagamento e reseta o saldo
      Repo.update_all(
        from(c in Client, where: c.id == ^client_id),
        set: [accumulated_balance: 0, pending_billing: new_accumulated_balance]
      )

      {:ok, "Cobrança pendente gerada de #{new_accumulated_balance} centavos"}
    else
      # Atualiza o saldo acumulado sem cobrança pendente
      Repo.update_all(
        from(c in Client, where: c.id == ^client_id),
        set: [accumulated_balance: new_accumulated_balance]
      )

      {:ok, "Saldo acumulado atualizado para #{new_accumulated_balance} centavos"}
    end
  end
end
