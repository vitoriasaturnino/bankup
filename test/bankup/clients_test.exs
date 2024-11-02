defmodule Bankup.ClientsTest do
  use Bankup.DataCase

  alias Bankup.Clients

  describe "clients" do
    alias Bankup.Clients.Client

    import Bankup.ClientsFixtures

    @invalid_attrs %{
      state: nil,
      full_name: nil,
      cpf_cnpj: nil,
      email: nil,
      phone: nil,
      whatsapp: nil,
      country: nil,
      city: nil,
      postal_code: nil,
      street_address: nil,
      birth_date: nil
    }

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Clients.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      valid_attrs = %{
        state: "some state",
        full_name: "some full_name",
        cpf_cnpj: "some cpf_cnpj",
        email: "some email",
        phone: "some phone",
        whatsapp: "some whatsapp",
        country: "some country",
        city: "some city",
        postal_code: "some postal_code",
        street_address: "some street_address",
        birth_date: ~D[2024-11-01]
      }

      assert {:ok, %Client{} = client} = Clients.create_client(valid_attrs)
      assert client.state == "some state"
      assert client.full_name == "some full_name"
      assert client.cpf_cnpj == "some cpf_cnpj"
      assert client.email == "some email"
      assert client.phone == "some phone"
      assert client.whatsapp == "some whatsapp"
      assert client.country == "some country"
      assert client.city == "some city"
      assert client.postal_code == "some postal_code"
      assert client.street_address == "some street_address"
      assert client.birth_date == ~D[2024-11-01]
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()

      update_attrs = %{
        state: "some updated state",
        full_name: "some updated full_name",
        cpf_cnpj: "some updated cpf_cnpj",
        email: "some updated email",
        phone: "some updated phone",
        whatsapp: "some updated whatsapp",
        country: "some updated country",
        city: "some updated city",
        postal_code: "some updated postal_code",
        street_address: "some updated street_address",
        birth_date: ~D[2024-11-02]
      }

      assert {:ok, %Client{} = client} = Clients.update_client(client, update_attrs)
      assert client.state == "some updated state"
      assert client.full_name == "some updated full_name"
      assert client.cpf_cnpj == "some updated cpf_cnpj"
      assert client.email == "some updated email"
      assert client.phone == "some updated phone"
      assert client.whatsapp == "some updated whatsapp"
      assert client.country == "some updated country"
      assert client.city == "some updated city"
      assert client.postal_code == "some updated postal_code"
      assert client.street_address == "some updated street_address"
      assert client.birth_date == ~D[2024-11-02]
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end
end
