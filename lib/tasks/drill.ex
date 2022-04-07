defmodule Mix.Tasks.Drill do
  use Mix.Task
  import Mix.Ecto

  alias Drill.Utils
  alias Ecto.Migrator

  @shortdoc "Seeding task"

  @impl Mix.Task
  @doc """
  API for running this task via mix command.
  """
  def run(args) do
    repo = parse_repo(args) |> hd()
    ensure_repo(repo, [])

    Migrator.with_repo(repo, fn repo ->
      Migrator.run(repo, :up, all: true)
      seed(repo)
    end)
  end

  def seed(repo) do
    {:ok, modules} = :application.get_key(:drill, :modules)

    seeder_modules =
      Enum.filter(modules, fn module ->
        Drill in (module.__info__(:attributes)[:behaviour] || [])
      end)

    Mix.shell().info("Arranging modules by dependencies")

    seeder_modules =
      seeder_modules
      |> Utils.sort_seeders_by_deps()
      |> warn_not_able_to_run_seeders(seeder_modules)

    Task.async(fn ->
      Enum.reduce(seeder_modules, %Drill.Context{}, fn seeder, ctx ->
        Mix.shell().info("#{seeder} started")

        entries = seeder.run(ctx)
        key = seeder.context_key()
        constraints = seeder.constraints()
        source = seeder.schema_or_source()

        {_, result} = insert_all(repo, source, entries, constraints)

        seeds = Map.put(ctx.seeds, key, result)
        Mix.shell().info("#{seeder} finished")
        %{ctx | seeds: seeds}
      end)
    end)
    |> Task.await()

    Mix.shell().info("Drill seeded successfully")
  end

  defp insert_all(repo, source, entries, []) do
    repo.insert_all(source, entries, returning: true)
  end

  defp insert_all(repo, source, entries, constraints) do
    repo.insert_all(source, entries,
      on_conflict: :replace_all,
      returning: true,
      conflict_target: constraints
    )
  end

  defp warn_not_able_to_run_seeders(arranged_seeders, all_seeders) do
    unmatched_seeders = all_seeders -- arranged_seeders

    if Enum.empty?(unmatched_seeders) do
      arranged_seeders
    else
      Mix.shell().info(
        "Unable to run seeders due to deps not found: #{inspect(unmatched_seeders)}"
      )

      arranged_seeders
    end
  end
end
