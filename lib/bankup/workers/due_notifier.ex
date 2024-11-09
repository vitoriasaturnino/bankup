defmodule Bankup.Notifications.DueNotifier do
  use Oban.Worker, queue: :default, max_attempts: 3

  import Ecto.Query, only: [where: 3]
  import Swoosh.Email

  alias Bankup.{Repo, Clients}
  alias Bankup.RecurringAccounts.RecurringAccount

  require Logger

  @impl Oban.Worker
  def perform(_) do
    today = Date.utc_today()

    # Obtenha todas as contas recorrentes que vencem hoje
    due_accounts =
      RecurringAccount
      |> where([a], a.due_date == ^today and a.status == "ativa")
      |> Repo.all()

    Enum.each(due_accounts, fn account ->
      client = Clients.get_client!(account.client_id)
      send_notification(client, account)
    end)

    :ok
  end

  defp send_notification(client, account) do
    case client.setting.notification_preference do
      "whatsapp" ->
        mock_send_whatsapp(client, account)

      "email" ->
        send_email(client, account)

      "ambos" ->
        send_email(client, account)
        mock_send_whatsapp(client, account)
    end
  end

  defp send_email(client, account) do
    email =
      new()
      |> to(client.email)
      |> from({"Bankup", "no-reply@bankup.com"})
      |> subject("Lembrete de pagamento: #{account.description}")
      |> html_body("""
      <h1>Conta Vencendo Hoje</h1>
      <p>Olá, #{client.full_name}</p>
      <p>O pagamento para a conta #{account.description} está vencendo hoje.</p>
      <p>Valor: R$ #{format_currency(account.amount)}</p>
      <p><a href="https://fake-pix.com/qrcode/#{account.pix_key}">Pague agora com PIX</a></p>
      """)

    Bankup.Mailer.deliver(email)
  end

  defp mock_send_whatsapp(client, account) do
    Logger.info("""
    [WHATSAPP MOCK] Enviando mensagem para #{client.full_name} (#{client.phone}):
    Conta: #{account.description}
    Valor: R$ #{format_currency(account.amount)}
    Link para pagamento PIX: https://fake-pix.com/qrcode/#{account.pix_key}
    """)
  end

  defp format_currency(amount) do
    amount
    |> Kernel./(100)
    |> :erlang.float_to_binary(decimals: 2)
  end
end
