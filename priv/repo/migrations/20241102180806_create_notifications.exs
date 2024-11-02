defmodule Bankup.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :client_id, references(:clients, on_delete: :delete_all), null: false
      add :account_id, references(:recurring_accounts, on_delete: :delete_all), null: false
      add :channel, :string, size: 20, default: "ambos"
      add :content, :text
      add :sent_at, :utc_datetime
      add :delivery_status, :string, size: 20, default: "pendente"
      timestamps()
    end

    create index(:notifications, [:client_id])
    create index(:notifications, [:account_id])
  end
end
