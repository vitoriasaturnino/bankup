defmodule Bankup.Settings.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field :notification_preference, :string
    field :penalty_limit, :decimal
    field :reminder_frequency, :integer
    field :client_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:notification_preference, :penalty_limit, :reminder_frequency])
    |> validate_required([:notification_preference, :penalty_limit, :reminder_frequency])
  end
end
