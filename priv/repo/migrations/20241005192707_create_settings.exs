defmodule Bankup.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :notification_preference, :string
      add :penalty_limit, :decimal
      add :reminder_frequency, :integer
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:settings, [:client_id])
  end
end
