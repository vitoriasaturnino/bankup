defmodule Bankup.RecurringAccounts.RecurringAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bankup.Clients.Client

  schema "recurring_accounts" do
    field :description, :string
    field :amount, :integer
    field :due_date, :date
    field :payee, :string
    field :pix_key, :string
    field :status, :string, default: "ativa"
    belongs_to :client, Client

    timestamps()
  end

  @doc false
  def changeset(recurring_account, attrs) do
    recurring_account
    |> cast(attrs, [:description, :amount, :due_date, :payee, :pix_key, :status, :client_id])
    |> validate_required([:description, :amount, :due_date, :payee, :status, :client_id])
    |> validate_number(:amount, greater_than: 0)
    |> assoc_constraint(:client)
  end
end
