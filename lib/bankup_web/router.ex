defmodule BankupWeb.Router do
  use BankupWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankupWeb do
    pipe_through :api
  end

  scope "/api", BankupWeb do
    pipe_through :api

    resources "/clients", ClientController, except: [:new, :edit]
    resources "/recurring_accounts", RecurringAccountController, except: [:new, :edit]
    resources "/payments", PaymentController, except: [:new, :edit]
    resources "/notifications", NotificationController, except: [:new, :edit]
    resources "/settings", SettingController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bankup, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BankupWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
