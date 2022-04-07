defmodule Drill.Context do
  @moduledoc """
  Seed struct containing all inserted items as seeds
  """
  @type t :: %__MODULE__{
          seeds: %{key: any()},
          seeders: [atom()],
          pending_seeders: [atom()],
          completed_seeders: [atom()]
        }

  defstruct seeds: %{}, seeders: [], pending_seeders: [], completed_seeders: []
end
