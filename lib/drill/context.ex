defmodule Drill.Context do
  @moduledoc """
  Seed struct containing all inserted items as seeds
  """
  @type t :: %__MODULE__{
          seeds: %{key: any()}
        }

  defstruct seeds: %{}
end
