defmodule Bankup.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :client_id, references(:clients, on_delete: :delete_all), null: false
      add :notification_preference, :string, size: 20, default: "ambos"
      add :penalty_limit, :integer, default: 0
      add :reminder_frequency, :integer, default: 1
      timestamps()
    end

    create unique_index(:settings, [:client_id])
  end
end
