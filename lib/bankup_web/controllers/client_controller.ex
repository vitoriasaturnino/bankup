defmodule BankupWeb.ClientController do
  use BankupWeb, :controller

  alias Bankup.Clients
  alias Bankup.Clients.Client

  action_fallback BankupWeb.FallbackController

  def index(conn, _params) do
    clients = Clients.list_clients()
    json(conn, %{data: clients})
  end

  def create(conn, %{"client" => client_params}) do
    with {:ok, %Client{} = client} <- Clients.create_client(client_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clients/#{client.id}")
      |> json(%{data: client})
    end
  end

  def show(conn, %{"id" => id}) do
    client = Clients.get_client!(id)
    json(conn, %{data: client})
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Clients.get_client!(id)

    with {:ok, %Client{} = client} <- Clients.update_client(client, client_params) do
      json(conn, %{data: client})
    end
  end

  def delete(conn, %{"id" => id}) do
    client = Clients.get_client!(id)

    with {:ok, %Client{}} <- Clients.delete_client(client) do
      send_resp(conn, :no_content, "")
    end
  end
end
