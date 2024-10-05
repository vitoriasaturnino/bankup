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
        sent_at: ~U[2024-10-04 19:26:00Z]
      })
      |> Bankup.Notifications.create_notification()

    notification
  end
end
