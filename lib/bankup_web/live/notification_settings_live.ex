defmodule BankupWeb.NotificationSettingsLive do
  use BankupWeb, :live_view
  alias Bankup.Clients
  alias Bankup.Settings

  def mount(_params, _session, socket) do
    # Carrega todos os clientes com suas configurações de notificação
    clients = Clients.list_all_clients()
    {:ok, assign(socket, clients: clients)}
  end

  def handle_event("save_settings", %{"notification_preference" => preferences}, socket) do
    # Atualiza as configurações de notificação para cada cliente
    Enum.each(preferences, fn {client_id, preference} ->
      # Atualiza a preferência de notificação para cada cliente usando a comparação correta
      client = Enum.find(socket.assigns.clients, &(&1.id == client_id))

      if client do
        Settings.update_client_preference(client, %{notification_preference: preference})
      end
    end)

    # Recarrega os clientes e suas configurações após a atualização
    updated_clients = Clients.list_all_clients()
    {:noreply, assign(socket, clients: updated_clients)}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-3xl px-10 py-16 bg-gradient-to-br from-green-100 to-green-200 shadow-2xl rounded-3xl">
      <h1 class="text-4xl font-semibold text-zinc-900 mb-10 tracking-tight text-center">
        Configurações de Notificação
      </h1>

      <form phx-submit="save_settings" class="space-y-10">
        <%= for client <- @clients do %>
          <div class="mb-6">
            <h2 class="text-2xl font-semibold text-zinc-800 mb-4">
              Cliente: <span class="font-semibold"><%= client.full_name %></span>
            </h2>

            <div class="flex flex-col">
              <label
                for={"notification_preference_#{client.id}"}
                class="text-lg font-medium text-zinc-800 mb-4"
              >
                Preferência de Notificação
              </label>
              <select
                name={"notification_preference[#{client.id}]"}
                id={"notification_preference_#{client.id}"}
                class="appearance-none px-4 py-3 rounded-lg border border-zinc-300 bg-white/80 text-zinc-700 shadow-md backdrop-blur-md focus:ring-2 focus:ring-green-500 focus:border-green-500 transition duration-200"
              >
                <option
                  value="whatsapp"
                  selected={client.setting.notification_preference == "whatsapp"}
                >
                  WhatsApp
                </option>
                <option value="email" selected={client.setting.notification_preference == "email"}>
                  E-mail
                </option>
                <option value="ambos" selected={client.setting.notification_preference == "ambos"}>
                  Ambos
                </option>
              </select>
            </div>
          </div>
        <% end %>

        <div class="mt-12 text-center">
          <button
            type="submit"
            class="w-full py-4 px-6 rounded-lg bg-green-600 text-white font-semibold text-lg shadow-lg hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2 transition-transform duration-200 hover:scale-105"
          >
            Salvar Todas as Preferências
          </button>
        </div>
      </form>
    </div>
    """
  end
end
