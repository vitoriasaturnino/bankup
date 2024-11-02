defmodule Bankup.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :client_id, references(:clients, type: :binary_id, on_delete: :delete_all), null: false

      add :recurring_account_id,
          references(:recurring_accounts, type: :binary_id, on_delete: :delete_all),
          null: false

      add :channel, :string, size: 20, default: "ambos"
      add :content, :text
      add :sent_at, :utc_datetime
      add :delivery_status, :string, size: 20, default: "pendente"
      timestamps()
    end

    create index(:notifications, [:client_id])
    create index(:notifications, [:recurring_account_id])
  end
end
