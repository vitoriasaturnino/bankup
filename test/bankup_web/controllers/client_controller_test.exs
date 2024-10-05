defmodule BankupWeb.ClientControllerTest do
  use BankupWeb.ConnCase

  alias Bankup.Clients
  alias Bankup.Clients.Client

  @valid_attrs %{
    full_name: "John Doe",
    cpf_cnpj: "12345678900",
    email: "john@example.com",
    phone: "123456789",
    whatsapp: "123456789",
    country: "Brazil",
    state: "SP",
    city: "Sao Paulo",
    postal_code: "12345-678",
    street_address: "123 Elm Street",
    birth_date: ~D[1990-01-01]
  }
  @invalid_attrs %{}

  describe "index/2" do
    test "lists all clients", %{conn: conn} do
      conn = get(conn, ~p"/api/clients")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create/2" do
    test "creates and renders client when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/clients", client: @valid_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clients/#{id}")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "does not create client and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/clients", client: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update/2" do
    setup [:create_client]

    test "updates and renders client when data is valid", %{conn: conn, client: client} do
      conn =
        put(conn, ~p"/api/clients/#{client.id}", client: %{@valid_attrs | full_name: "Jane Doe"})

      assert %{"id" => ^client.id, "full_name" => "Jane Doe"} = json_response(conn, 200)["data"]
    end

    test "does not update client and renders errors when data is invalid", %{
      conn: conn,
      client: client
    } do
      conn = put(conn, ~p"/api/clients/#{client.id}", client: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup [:create_client]

    test "deletes chosen client", %{conn: conn, client: client} do
      conn = delete(conn, ~p"/api/clients/#{client.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clients/#{client.id}")
      end
    end
  end

  defp create_client(_) do
    {:ok, client} = Clients.create_client(@valid_attrs)
    %{client: client}
  end
end
