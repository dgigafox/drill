defmodule Drill.Utils do
  @moduledoc """
  Utilities and helpers
  """

  @doc """
  Sort seeder modules by dependencies. Seeders without deps are put first in the list,
  next to seeders with deps already in the list, and so on...
  """
  def sort_seeders_by_deps(seeders) do
    seeders_with_no_deps = Enum.filter(seeders, &Enum.empty?(&1.deps))

    seeders_with_no_deps
    |> do_sort_seeders_by_deps(seeders -- seeders_with_no_deps)
    |> Enum.reverse()
  end

  defp do_sort_seeders_by_deps(arranged_seeders, remaining_seeders) do
    next_seeders =
      Enum.filter(
        remaining_seeders,
        &MapSet.subset?(MapSet.new(&1.deps), MapSet.new(arranged_seeders))
      )

    arranged_seeders = List.flatten([next_seeders | arranged_seeders])

    if Enum.empty?(next_seeders) do
      arranged_seeders
    else
      do_sort_seeders_by_deps(arranged_seeders, remaining_seeders -- next_seeders)
    end
  end
end
