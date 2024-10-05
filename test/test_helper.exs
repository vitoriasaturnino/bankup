ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Bankup.Repo, :manual)

Mox.defmock(EmailNotifierMock, for: Bankup.Notifications.EmailNotifier)
Mox.defmock(WhatsAppNotifierMock, for: Bankup.Notifications.WhatsAppNotifier)
