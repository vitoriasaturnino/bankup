defmodule Bankup.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :channel, :string
    field :content, :string
    field :sent_at, :utc_datetime
    field :delivery_status, :string
    field :client_id, :id
    field :account_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:channel, :content, :sent_at, :delivery_status])
    |> validate_required([:channel, :content, :sent_at, :delivery_status])
  end
end
