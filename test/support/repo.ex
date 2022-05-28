defmodule Drill.Test.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :drill,
    adapter: Ecto.Adapters.Postgres
end
