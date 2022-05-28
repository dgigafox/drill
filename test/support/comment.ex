defmodule Drill.Test.Comment do
  @moduledoc false
  use Ecto.Schema

  schema "comments" do
    field(:content, :string)
    belongs_to(:user, Drill.Test.User)
    belongs_to(:post, Drill.Test.Post)

    timestamps()
  end
end
