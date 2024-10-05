defmodule Bankup.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :amount_paid, :decimal
    field :payment_date, :utc_datetime
    field :payment_method, :string
    field :payment_status, :string
    field :penalty_applied, :decimal

    belongs_to :account, Bankup.RecurringAccounts.RecurringAccount

    timestamps()
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :amount_paid,
      :payment_date,
      :payment_method,
      :payment_status,
      :penalty_applied,
      :account_id
    ])
    |> validate_required([
      :amount_paid,
      :payment_date,
      :payment_method,
      :payment_status,
      :account_id
    ])
  end
end
