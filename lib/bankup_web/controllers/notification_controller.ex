defmodule BankupWeb.NotificationController do
  use BankupWeb, :controller

  alias Bankup.Notifications
  alias Bankup.Notifications.Notification

  action_fallback BankupWeb.FallbackController

  def index(conn, _params) do
    notifications = Notifications.list_notifications()
    json(conn, %{data: notifications})
  end

  def create(conn, %{"notification" => notification_params}) do
    with {:ok, %Notification{} = notification} <-
           Notifications.create_notification(notification_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/notifications/#{notification.id}")
      |> json(%{data: notification})
    end
  end

  def show(conn, %{"id" => id}) do
    notification = Notifications.get_notification!(id)
    json(conn, %{data: notification})
  end

  def update(conn, %{"id" => id, "notification" => notification_params}) do
    notification = Notifications.get_notification!(id)

    with {:ok, %Notification{} = notification} <-
           Notifications.update_notification(notification, notification_params) do
      json(conn, %{data: notification})
    end
  end

  def delete(conn, %{"id" => id}) do
    notification = Notifications.get_notification!(id)

    with {:ok, %Notification{}} <- Notifications.delete_notification(notification) do
      send_resp(conn, :no_content, "")
    end
  end
end
