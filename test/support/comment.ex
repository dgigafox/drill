defmodule Drill.Demo.Comment do
  @moduledoc false
  use Ecto.Schema

  schema "comments" do
    field(:content, :string)
    belongs_to(:user, Drill.Demo.User)
    belongs_to(:post, Drill.Demo.Post)

    timestamps()
  end
end
