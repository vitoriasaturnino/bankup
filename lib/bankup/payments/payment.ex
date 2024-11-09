defmodule Bankup.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bankup.RecurringAccounts.RecurringAccount

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount_paid, :integer
    field :payment_date, :utc_datetime
    field :payment_method, :string, default: "PIX"
    field :payment_status, :string, default: "pendente"
    field :penalty_applied, :integer
    belongs_to :recurring_account, RecurringAccount

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :recurring_account_id,
      :amount_paid,
      :payment_date,
      :payment_method,
      :payment_status,
      :penalty_applied
    ])
    |> validate_required([:recurring_account_id, :payment_status])
    |> validate_inclusion(:payment_status, ["pendente", "concluído", "falhou"])
    |> assoc_constraint(:recurring_account)
  end
end
