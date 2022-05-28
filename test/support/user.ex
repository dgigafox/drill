defmodule Drill.Test.User do
  @moduledoc """
  Demo user
  """
  use Ecto.Schema

  schema "users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)

    timestamps()
  end
end
