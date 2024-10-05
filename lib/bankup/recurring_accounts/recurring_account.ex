defmodule Bankup.RecurringAccounts.RecurringAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recurring_accounts" do
    field :description, :string
    field :amount, :decimal
    field :due_date, :date
    field :payee, :string
    field :pix_key, :string
    field :status, :string

    # Definindo a associação com Client
    belongs_to :client, Bankup.Clients.Client

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:description, :amount, :due_date, :payee, :pix_key, :status, :client_id])
    |> validate_required([:description, :amount, :due_date, :payee, :pix_key, :status, :client_id])
  end
end
