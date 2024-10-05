defmodule Bankup.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :amount_paid, :decimal
    field :payment_date, :utc_datetime
    field :payment_method, :string
    field :payment_status, :string
    field :penalty_applied, :decimal
    field :account_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount_paid, :payment_date, :payment_method, :payment_status, :penalty_applied])
    |> validate_required([:amount_paid, :payment_date, :payment_method, :payment_status, :penalty_applied])
  end
end
