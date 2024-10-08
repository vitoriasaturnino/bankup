defmodule BankupWeb.PaymentController do
  use BankupWeb, :controller

  alias Bankup.Payments
  alias Bankup.Payments.Payment
  alias Bankup.Notifications.{EmailNotifier, WhatsAppNotifier}

  action_fallback BankupWeb.FallbackController

  def index(conn, _params) do
    payments = Payments.list_payments()
    json(conn, %{data: payments})
  end

  def create(conn, %{"payment" => payment_params}) do
    with {:ok, %Payment{} = payment} <- Payments.create_payment(payment_params),
         # Carregar a associação account e client
         payment <- Bankup.Repo.preload(payment, account: [:client]) do
      client = payment.account.client

      EmailNotifier.send_payment_notification(client.email, payment)

      WhatsAppNotifier.send_whatsapp_message(
        client.whatsapp,
        "Payment created for account: #{payment.account.description}"
      )

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/payments/#{payment.id}")
      |> json(%{data: payment})
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    json(conn, %{data: payment})
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)

    with {:ok, %Payment{} = payment} <- Payments.update_payment(payment, payment_params) do
      json(conn, %{data: payment})
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)

    with {:ok, %Payment{}} <- Payments.delete_payment(payment) do
      send_resp(conn, :no_content, "")
    end
  end
end
