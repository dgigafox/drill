defmodule Drill.Context do
  @moduledoc """
  Seed struct containing all inserted items as seeds
  """
  @type t :: %__MODULE__{
          seeds: %{atom() => any()},
          seeders: [atom()],
          pending_seeders: [atom()],
          completed_seeders: [atom()],
          seed_count: %{atom() => integer() | {:for_each, atom(), keyword()}}
        }

  defstruct seeds: %{}, seeders: [], pending_seeders: [], completed_seeders: [], seed_count: %{}
end
