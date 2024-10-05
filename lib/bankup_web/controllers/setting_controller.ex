defmodule BankupWeb.SettingController do
  use BankupWeb, :controller

  alias Bankup.Settings
  alias Bankup.Settings.Setting

  action_fallback BankupWeb.FallbackController

  def index(conn, _params) do
    settings = Settings.list_settings()
    json(conn, %{data: settings})
  end

  def create(conn, %{"setting" => setting_params}) do
    with {:ok, %Setting{} = setting} <- Settings.create_setting(setting_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/settings/#{setting.id}")
      |> json(%{data: setting})
    end
  end

  def show(conn, %{"id" => id}) do
    setting = Settings.get_setting!(id)
    json(conn, %{data: setting})
  end

  def update(conn, %{"id" => id, "setting" => setting_params}) do
    setting = Settings.get_setting!(id)

    with {:ok, %Setting{} = setting} <- Settings.update_setting(setting, setting_params) do
      json(conn, %{data: setting})
    end
  end

  def delete(conn, %{"id" => id}) do
    setting = Settings.get_setting!(id)

    with {:ok, %Setting{}} <- Settings.delete_setting(setting) do
      send_resp(conn, :no_content, "")
    end
  end
end
