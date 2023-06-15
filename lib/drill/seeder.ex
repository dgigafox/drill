defmodule Drill.Seeder do
  @moduledoc """
  Module responsible for seeding data into the database
  """
  @spec list_seeder_modules(repo :: module(), directory :: binary()) :: [module()]
  def list_seeder_modules(repo, directory \\ "seeds") do
    repo
    |> seeders_path(directory)
    |> list_seeder_files()
    |> compile_seeders()
    |> Enum.filter(&seeder?/1)
  end

  defp seeders_path(repo, directory) do
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
end
