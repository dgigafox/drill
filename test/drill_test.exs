defmodule DrillTest do
  use ExUnit.Case
  doctest Drill

  contents =
    quote do
      use Drill, source: MySource, key: :my_key

      def factory, do: %{}
      def run(_), do: []
    end

  Module.create(Demo, contents, Macro.Env.location(__ENV__))

  test "definitions" do
    assert Demo.__info__(:functions) == [
             autogenerate: 0,
             build: 0,
             build: 1,
             constraints: 0,
             context_key: 0,
             deps: 0,
             factory: 0,
             run: 1,
             schema: 0
           ]
  end

  test "context_key/0 returns opts `:key`" do
    assert Demo.context_key() == :my_key
  end

  test "schema/0 returns opts `:source`" do
    assert Demo.schema() == MySource
  end

  test "deps/0 and constraints/0 returns empty list by default" do
    assert Demo.constraints() == []
    assert Demo.deps() == []
  end
end
