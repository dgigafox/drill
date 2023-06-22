defmodule Drill.Seeder do
  @moduledoc """
  Module responsible for seeding data into the database
  """
  alias Drill.Seed
  @spec list_seeder_modules(seeders_path :: binary()) :: [module()]
  def list_seeder_modules(seeders_path) do
    seeders_path
    |> list_seeder_files()
    |> compile_seeders()
    |> Enum.filter(&seeder?/1)
  end

  def seeders_path(repo, directory) do
    config = repo.config()
    priv = config[:priv] || "priv/#{repo |> Module.split() |> List.last() |> Macro.underscore()}"
    app = Keyword.fetch!(config, :otp_app)
    Application.app_dir(app, Path.join(priv, directory))
  end

  defp list_seeder_files(seeders_source) do
    Path.join([seeders_source, "**", "*.exs"])
    |> Path.wildcard()
  end

  defp compile_seeders(files) do
    files
    |> Enum.flat_map(fn file ->
      file
      |> Code.compile_file()
      |> Enum.map(&elem(&1, 0))
    end)
  end

  defp seeder?(module) do
    Drill in (module.__info__(:attributes)[:behaviour] || [])
  end

  @spec build_entries(module(), Drill.Context.t()) :: list(map())
  def build_entries(seeder, ctx) do
    ctx
    |> seeder.run()
    |> Enum.filter(&is_struct(&1, Seed))
    |> Enum.map(& &1.attrs)
  end

  @spec filter_manual_seeds(module(), Drill.Context.t()) :: list(any())
  def filter_manual_seeds(seeder, ctx) do
    ctx
    |> seeder.run()
    |> Enum.reject(&is_struct(&1, Seed))
  end

  @spec autogenerate_fields(module()) :: map()
  def autogenerate_fields(schema) do
    for {fields, {func, name, args}} <- schema.__schema__(:autogenerate),
        field <- fields,
        into: %{} do
      {field, apply(func, name, args)}
    end
  end
end
