defmodule Bankup.RecurringAccounts do
  @moduledoc """
  The RecurringAccounts context.
  """

  import Ecto.Query, warn: false
  alias Bankup.Repo

  alias Bankup.RecurringAccounts.RecurringAccount

  @doc """
  Returns the list of recurring_accounts.

  ## Examples

      iex> list_recurring_accounts()
      [%RecurringAccount{}, ...]

  """
  def list_recurring_accounts do
    Repo.all(RecurringAccount)
  end

  @doc """
  Gets a single recurring_account.

  Raises `Ecto.NoResultsError` if the Recurring account does not exist.

  ## Examples

      iex> get_recurring_account!(123)
      %RecurringAccount{}

      iex> get_recurring_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recurring_account!(id), do: Repo.get!(RecurringAccount, id)

  @doc """
  Creates a recurring_account.

  ## Examples

      iex> create_recurring_account(%{field: value})
      {:ok, %RecurringAccount{}}

      iex> create_recurring_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recurring_account(attrs \\ %{}) do
    %RecurringAccount{}
    |> RecurringAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recurring_account.

  ## Examples

      iex> update_recurring_account(recurring_account, %{field: new_value})
      {:ok, %RecurringAccount{}}

      iex> update_recurring_account(recurring_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recurring_account(%RecurringAccount{} = recurring_account, attrs) do
    recurring_account
    |> RecurringAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recurring_account.

  ## Examples

      iex> delete_recurring_account(recurring_account)
      {:ok, %RecurringAccount{}}

      iex> delete_recurring_account(recurring_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recurring_account(%RecurringAccount{} = recurring_account) do
    Repo.delete(recurring_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recurring_account changes.

  ## Examples

      iex> change_recurring_account(recurring_account)
      %Ecto.Changeset{data: %RecurringAccount{}}

  """
  def change_recurring_account(%RecurringAccount{} = recurring_account, attrs \\ %{}) do
    RecurringAccount.changeset(recurring_account, attrs)
  end
end
