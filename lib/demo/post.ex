defmodule Drill.Demo.Post do
  @moduledoc false
  use Ecto.Schema

  schema "posts" do
    field(:content, :string)
    belongs_to(:user, Drill.Demo.User)

    timestamps()
  end
end
