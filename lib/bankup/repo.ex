defmodule Bankup.Repo do
  use Ecto.Repo,
    otp_app: :bankup,
    adapter: Ecto.Adapters.Postgres
end
