defmodule Bankup.SettingsTest do
  use Bankup.DataCase

  alias Bankup.Settings

  describe "settings" do
    alias Bankup.Settings.Setting

    import Bankup.SettingsFixtures

    @invalid_attrs %{notification_preference: nil, penalty_limit: nil, reminder_frequency: nil}

    test "list_settings/0 returns all settings" do
      setting = setting_fixture()
      assert Settings.list_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Settings.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      valid_attrs = %{notification_preference: "some notification_preference", penalty_limit: 42, reminder_frequency: 42}

      assert {:ok, %Setting{} = setting} = Settings.create_setting(valid_attrs)
      assert setting.notification_preference == "some notification_preference"
      assert setting.penalty_limit == 42
      assert setting.reminder_frequency == 42
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      update_attrs = %{notification_preference: "some updated notification_preference", penalty_limit: 43, reminder_frequency: 43}

      assert {:ok, %Setting{} = setting} = Settings.update_setting(setting, update_attrs)
      assert setting.notification_preference == "some updated notification_preference"
      assert setting.penalty_limit == 43
      assert setting.reminder_frequency == 43
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_setting(setting, @invalid_attrs)
      assert setting == Settings.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Settings.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Settings.change_setting(setting)
    end
  end
end
