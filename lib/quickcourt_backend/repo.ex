defmodule QuickcourtBackend.Repo do
  use Ecto.Repo,
    otp_app: :quickcourt_backend,
    adapter: Ecto.Adapters.Postgres
end
