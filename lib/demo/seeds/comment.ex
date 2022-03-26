defmodule Drill.Demo.CommentSeed do
  use Drill, key: :comment

  @impl true
  def deps do
    [Drill.Demo.Post]
  end

  @impl true
  def run(%Drill.Context{}) do
  end
end
