defmodule BankupWeb.ClientView do
  use BankupWeb, :view
  alias BankupWeb.ClientView

  def render("index.json", %{clients: clients}) do
    %{data: render_many(clients, ClientView, "client.json")}
  end

  def render("show.json", %{client: client}) do
    %{data: render_one(client, ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{
      id: client.id,
      full_name: client.full_name,
      cpf_cnpj: client.cpf_cnpj,
      email: client.email,
      phone: client.phone,
      whatsapp: client.whatsapp,
      country: client.country,
      state: client.state,
      city: client.city,
      postal_code: client.postal_code,
      street_address: client.street_address,
      birth_date: client.birth_date
    }
  end
end
