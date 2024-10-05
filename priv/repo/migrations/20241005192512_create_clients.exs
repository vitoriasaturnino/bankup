defmodule Bankup.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :full_name, :string
      add :cpf_cnpj, :string
      add :email, :string
      add :phone, :string
      add :whatsapp, :string
      add :country, :string
      add :state, :string
      add :city, :string
      add :postal_code, :string
      add :street_address, :string
      add :birth_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
