defmodule Drill.Demo.PostSeed do
  use Drill, key: :post

  @impl true
  def deps do
    [Drill.Demo.User]
  end

  @impl true
  def run(%Drill.Context{}) do
    []
  end
end
