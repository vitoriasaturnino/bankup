defmodule Bankup.Settings.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "settings" do
    field :notification_preference, :string
    field :penalty_limit, :integer
    field :reminder_frequency, :integer

    belongs_to :client,Bankup.Clients.Client, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:client_id, :notification_preference, :penalty_limit, :reminder_frequency])
    |> validate_required([:notification_preference, :penalty_limit, :reminder_frequency])
  end
end
