defmodule Bankup.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :account_id, references(:recurring_accounts, on_delete: :delete_all), null: false
      add :amount_paid, :integer
      add :payment_date, :utc_datetime
      add :payment_method, :string, size: 20, default: "PIX"
      add :payment_status, :string, size: 20, default: "pendente"
      add :penalty_applied, :integer
      timestamps()
    end

    create index(:payments, [:account_id])
  end
end
