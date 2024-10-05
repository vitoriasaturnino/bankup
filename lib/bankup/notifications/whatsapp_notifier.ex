defmodule Bankup.Notifications.WhatsAppNotifier do
  @callback send_whatsapp_message(String.t(), String.t()) :: :ok | {:error, String.t()}

  def send_whatsapp_message(client_phone, message) do
    IO.puts("Enviando mensagem para #{client_phone}: #{message}")
    :ok
  end
end
