defmodule Drill.Test.Post do
  @moduledoc false
  use Ecto.Schema

  schema "posts" do
    field(:content, :string)
    belongs_to(:user, Drill.Test.User)

    timestamps()
  end
end
