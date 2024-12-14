defmodule Ganzo.Repo do
  use Ecto.Repo,
    otp_app: :ganzo,
    adapter: Ecto.Adapters.Postgres
end
