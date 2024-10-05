defmodule Bankup.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :channel, :string
      add :content, :text
      add :sent_at, :utc_datetime
      add :delivery_status, :string
      add :client_id, references(:clients, on_delete: :nothing)
      add :account_id, references(:recurring_accounts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:notifications, [:client_id])
    create index(:notifications, [:account_id])
  end
end
