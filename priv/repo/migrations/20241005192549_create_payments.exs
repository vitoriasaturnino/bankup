defmodule Bankup.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount_paid, :decimal
      add :payment_date, :utc_datetime
      add :payment_method, :string
      add :payment_status, :string
      add :penalty_applied, :decimal
      add :account_id, references(:recurring_accounts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:payments, [:account_id])
  end
end
