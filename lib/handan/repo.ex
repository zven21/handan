defmodule Handan.Repo do
  use Ecto.Repo,
    otp_app: :handan,
    adapter: Ecto.Adapters.Postgres
end
