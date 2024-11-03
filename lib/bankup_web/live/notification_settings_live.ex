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
    <h1>Configurações de Notificação</h1>
    <form phx-submit="save_settings">
      <label>Preferência de Notificação:</label>
      <select name="notification_preference">
        <option value="whatsapp" selected={@settings.notification_preference == "whatsapp"}>
          WhatsApp
        </option>
        <option value="email" selected={@settings.notification_preference == "email"}>E-mail</option>
        <option value="ambos" selected={@settings.notification_preference == "ambos"}>Ambos</option>
      </select>

      <button type="submit">Salvar</button>
    </form>
    """
  end
end
