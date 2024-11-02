defmodule Bankup.RecurringAccounts do
  use Ecto.Schema

  alias Bankup.Repo
  alias Bankup.RecurringAccounts.RecurringAccount

  @doc """
  Cria uma nova conta recorrente associada a um cliente.
  """
  def create_recurring_account(attrs \\ %{}) do
    %RecurringAccount{}
    |> RecurringAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Atualiza uma conta recorrente existente.
  """
  def update_recurring_account(%RecurringAccount{} = account, attrs) do
    account
    |> RecurringAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Inativa uma conta recorrente, alterando o status para "inativa".
  """
  def deactivate_recurring_account(%RecurringAccount{} = account) do
    update_recurring_account(account, %{status: "inativa"})
  end
end
