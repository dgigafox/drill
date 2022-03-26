defmodule Drill.Demo.UserSeed do
  use Drill, key: :user

  @impl true
  def run(%Drill.Context{}) do
    []
  end
end
