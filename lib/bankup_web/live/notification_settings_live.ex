defmodule BankupWeb.NotificationSettingsLive do
  use BankupWeb, :live_view
  alias Bankup.Settings

  def mount(_params, _session, socket) do
    # Substituir pelo ID do cliente autenticado em um sistema real
    client_id = "300401f4-0f42-4f25-b6ed-fb69464d2cd3"
    settings = Settings.get_preferences(client_id)
    {:ok, assign(socket, settings: settings)}
  end

  def handle_event("save_settings", %{"notification_preference" => preference}, socket) do
    Settings.update_preference(socket.assigns.settings, %{notification_preference: preference})

    {:noreply,
     assign(socket, settings: Settings.get_preferences(socket.assigns.settings.client_id))}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl px-8 py-12 bg-gradient-to-b from-white to-zinc-100 shadow-2xl rounded-3xl">
      <h1 class="text-4xl font-semibold text-zinc-900 mb-8 tracking-tight">
        Configurações de Notificação
      </h1>
      <form phx-submit="save_settings" class="space-y-6">
        <div class="flex flex-col">
          <label for="notification_preference" class="text-lg font-medium text-zinc-800 mb-2">
            Preferência de Notificação
          </label>
          <select
            name="notification_preference"
            id="notification_preference"
            class="appearance-none px-4 py-3 rounded-lg border border-zinc-300 bg-zinc-50 text-zinc-700 focus:ring-2 focus:ring-green-500 focus:border-green-500"
          >
            <option value="whatsapp" selected={@settings.notification_preference == "whatsapp"}>
              WhatsApp
            </option>
            <option value="email" selected={@settings.notification_preference == "email"}>
              E-mail
            </option>
            <option value="ambos" selected={@settings.notification_preference == "ambos"}>
              Ambos
            </option>
          </select>
        </div>

        <div class="mt-8">
          <button
            type="submit"
            class="w-full py-3 px-6 rounded-lg bg-green-600 text-white font-semibold text-lg shadow-lg hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2 transition-transform duration-200 hover:scale-105"
          >
            Salvar
          </button>
        </div>
      </form>
    </div>
    """
  end
end
