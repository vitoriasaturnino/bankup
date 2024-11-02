defmodule Bankup.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankup.Settings` context.
  """

  @doc """
  Generate a setting.
  """
  def setting_fixture(attrs \\ %{}) do
    {:ok, setting} =
      attrs
      |> Enum.into(%{
        notification_preference: "some notification_preference",
        penalty_limit: 42,
        reminder_frequency: 42
      })
      |> Bankup.Settings.create_setting()

    setting
  end
end
