defmodule Bankup.Repo.Migrations.CreateRecurringAccounts do
  use Ecto.Migration

  def change do
    create table(:recurring_accounts, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :client_id, references(:clients, type: :binary_id), null: false
      add :description, :string, null: false
      # Armazenado em centavos
      add :amount, :integer, null: false
      add :due_date, :date, null: false
      add :payee, :string, null: false
      add :pix_key, :string, size: 32
      add :status, :string, size: 20, default: "ativa"
      timestamps()
    end
  end
end
