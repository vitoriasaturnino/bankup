defmodule Bankup.Repo.Migrations.CreateRecurringAccounts do
  use Ecto.Migration

  def change do
    create table(:recurring_accounts) do
      add :description, :string
      add :amount, :decimal
      add :due_date, :date
      add :payee, :string
      add :pix_key, :string
      add :status, :string
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:recurring_accounts, [:client_id])
  end
end
