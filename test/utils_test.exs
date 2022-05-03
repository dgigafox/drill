defmodule Seeder1 do
  def deps, do: []
end

defmodule Seeder2 do
  def deps, do: [Seeder1]
end

defmodule Seeder3 do
  def deps, do: [Seeder1, Seeder2]
end

defmodule SeederWithUnmatchingDeps do
  def deps, do: [CannotMatchSeeder]
end

defmodule Drills.UtilsTest do
  use ExUnit.Case, async: true
  alias Drill.Utils

  test "sort_seeders_by_deps/1" do
    actual_result =
      Utils.sort_seeders_by_deps(
        Enum.shuffle([
          Seeder1,
          Seeder2,
          Seeder3,
          SeederWithUnmatchingDeps
        ])
      )

    assert actual_result == [Seeder1, Seeder2, Seeder3]
  end
end
