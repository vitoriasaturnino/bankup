defmodule Bankup.NotificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankup.Notifications` context.
  """

  @doc """
  Generate a notification.
  """
  def notification_fixture(attrs \\ %{}) do
    {:ok, notification} =
      attrs
      |> Enum.into(%{
        channel: "some channel",
        content: "some content",
        delivery_status: "some delivery_status",
        sent_at: ~U[2024-11-01 18:18:00Z]
      })
      |> Bankup.Notifications.create_notification()

    notification
  end
end
