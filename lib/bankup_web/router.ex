defmodule BankupWeb.Router do
  use BankupWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BankupWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankupWeb do
    pipe_through :browser

    get "/", PageController, :home

    # Rotas para LiveViews
    live "/dashboard", DashboardLive
    live "/contas-recorrentes", RecurringAccountsLive
    live "/historico-pagamentos", PaymentsHistoryLive
    live "/configuracoes-notificacoes", NotificationSettingsLive
  end

  # Outras rotas personalizadas (API etc.)
  # scope "/api", BankupWeb do
  #   pipe_through :api
  # end

  # Habilitar o LiveDashboard e visualização de e-mails do Swoosh no desenvolvimento
  if Application.compile_env(:bankup, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BankupWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
