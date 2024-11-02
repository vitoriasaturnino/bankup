defmodule Bankup.Repo.Migrations.CreateRecurringAccounts do
  use Ecto.Migration

  def change do
    create table(:recurring_accounts) do
      add :client_id, references(:clients, on_delete: :delete_all), null: false
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
