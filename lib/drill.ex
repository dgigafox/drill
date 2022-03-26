defmodule Drill do
  @moduledoc """
  Drill is an elixir seeder library with back-pressure
  """
  alias Drill.Context

  @callback deps() :: [atom()]
  @callback run(Context.t()) :: {:ok, Context.t()} | {:error, any}

  defmacro __using__(opts \\ []) when is_list(opts) do
    quote do
      @behaviour Drill

      def context_key, do: unquote(opts[:key])

      @impl true
      def deps, do: []

      defoverridable deps: 0
    end
  end
end
