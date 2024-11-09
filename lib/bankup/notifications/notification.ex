defmodule Bankup.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bankup.Clients.Client
  alias Bankup.RecurringAccounts.RecurringAccount

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notifications" do
    field :channel, :string, default: "ambos"
    field :content, :string
    field :sent_at, :utc_datetime
    field :delivery_status, :string, default: "pendente"
    belongs_to :client, Client
    belongs_to :recurring_account, RecurringAccount

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:client_id, :recurring_account_id, :channel, :content, :sent_at, :delivery_status])
    |> validate_required([:client_id, :recurring_account_id, :channel, :content, :delivery_status])
    |> assoc_constraint(:client)
    |> assoc_constraint(:recurring_account)
  end
end
