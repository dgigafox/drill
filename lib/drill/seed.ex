defmodule Drill.Seed do
  @moduledoc "Contains helper and struct definition for seeds"
  @type t :: %__MODULE__{
          attrs: map()
        }
  defstruct attrs: %{}

  def new(seeder, attrs \\ []) do
    input_attrs = Map.new(attrs)
    full_attrs = seeder.factory() |> Map.merge(input_attrs)
    %__MODULE__{attrs: full_attrs}
  end
end
