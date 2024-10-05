defmodule Bankup.Notifications.EmailNotifier do
  @callback send_payment_notification(String.t(), map()) :: :ok | {:error, String.t()}

  import Swoosh.Email
  alias Bankup.Mailer

  def send_payment_notification(client_email, payment_details) do
    new()
    |> to(client_email)
    |> from("no-reply@bankup.com")
    |> subject("Payment Notification")
    |> html_body("Your payment details: #{payment_details}")
    |> Mailer.deliver()
  end
end
