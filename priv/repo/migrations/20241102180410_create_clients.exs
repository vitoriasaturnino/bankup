defmodule Bankup.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :full_name, :string, null: false
      add :cpf_cnpj, :string, size: 14, null: false
      add :email, :string, null: false
      add :phone, :string, size: 15
      add :whatsapp, :string, size: 15
      add :country, :string
      add :state, :string
      add :city, :string
      add :postal_code, :string, size: 20
      add :street_address, :string
      add :birth_date, :date
      timestamps()
    end
  end
end
