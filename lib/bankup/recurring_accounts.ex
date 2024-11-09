defmodule Bankup.RecurringAccounts do
  use Ecto.Schema

  import Ecto.Query

  alias Bankup.Repo
  alias Bankup.RecurringAccounts.RecurringAccount

  def get_account!(id) do
    Repo.get!(RecurringAccount, id)
  end

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

  def list_accounts(client_id) do
    RecurringAccount
    |> where([a], a.client_id == ^client_id)
    |> Repo.all()
  end

  def mark_as_paid(account_id) do
    account = Repo.get!(RecurringAccount, account_id)

    account
    |> Ecto.Changeset.change(
      status: "pago",
      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    )
    |> Repo.update()
  end
end
