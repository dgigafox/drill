defmodule Drill do
  @moduledoc """
  Drill is an elixir seeder library with back-pressure
  """
  alias Drill.Context

  @callback deps() :: [atom()]
  @callback run(Context.t()) :: [map()]
  @callback constraints() :: [atom()]

  defmacro __using__(opts \\ []) when is_list(opts) do
    quote do
      @behaviour Drill

      def context_key, do: unquote(opts[:key])
      def schema, do: unquote(opts[:source])

      @impl true
      def constraints, do: []

      @impl true
      def deps, do: []

      def autogenerate do
        for {fields, {func, name, args}} <- schema().__schema__(:autogenerate),
            field <- fields,
            into: %{} do
          {field, apply(func, name, args)}
        end
      end

      defoverridable deps: 0, constraints: 0
    end
  end
end
