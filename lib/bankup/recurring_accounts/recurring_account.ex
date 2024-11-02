defmodule Bankup.RecurringAccounts.RecurringAccount do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recurring_accounts" do
    field :status, :string
    field :description, :string
    field :amount, :integer
    field :due_date, :date
    field :payee, :string
    field :pix_key, :string
    field :client_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recurring_account, attrs) do
    recurring_account
    |> cast(attrs, [:description, :amount, :due_date, :payee, :pix_key, :status])
    |> validate_required([:description, :amount, :due_date, :payee, :pix_key, :status])
  end
end
