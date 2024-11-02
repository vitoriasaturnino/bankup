defmodule Bankup.Payments do
  use Ecto.Schema

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
end
