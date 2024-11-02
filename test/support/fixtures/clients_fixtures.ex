defmodule Bankup.ClientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankup.Clients` context.
  """

  @doc """
  Generate a client.
  """
  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2024-11-01],
        city: "some city",
        country: "some country",
        cpf_cnpj: "some cpf_cnpj",
        email: "some email",
        full_name: "some full_name",
        phone: "some phone",
        postal_code: "some postal_code",
        state: "some state",
        street_address: "some street_address",
        whatsapp: "some whatsapp"
      })
      |> Bankup.Clients.create_client()

    client
  end
end
