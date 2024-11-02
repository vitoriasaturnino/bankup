defmodule Bankup.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clients" do
    field :state, :string
    field :full_name, :string
    field :cpf_cnpj, :string
    field :email, :string
    field :phone, :string
    field :whatsapp, :string
    field :country, :string
    field :city, :string
    field :postal_code, :string
    field :street_address, :string
    field :birth_date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [
      :full_name,
      :cpf_cnpj,
      :email,
      :phone,
      :whatsapp,
      :country,
      :state,
      :city,
      :postal_code,
      :street_address,
      :birth_date
    ])
    |> validate_required([
      :full_name,
      :cpf_cnpj,
      :email,
      :phone,
      :whatsapp,
      :country,
      :state,
      :city,
      :postal_code,
      :street_address,
      :birth_date
    ])
  end
end
