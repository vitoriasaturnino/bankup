defmodule Bankup.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      add :recurring_account_id,
          references(:recurring_accounts, type: :binary_id, on_delete: :delete_all),
          null: false

      add :amount_paid, :integer
      add :payment_date, :utc_datetime
      add :payment_method, :string, size: 20, default: "PIX"
      add :payment_status, :string, size: 20, default: "pendente"
      add :penalty_applied, :integer
      timestamps()
    end

    create index(:payments, [:recurring_account_id])
  end
end
