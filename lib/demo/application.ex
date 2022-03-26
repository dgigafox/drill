defmodule Drill.Demo.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      Drill.Demo.Repo
    ]

    opts = [strategy: :one_for_one, name: Ecto.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
