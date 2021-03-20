defmodule Retrospectives.Repo do
  use Ecto.Repo,
    otp_app: :retrospectives,
    adapter: Ecto.Adapters.Postgres
end
