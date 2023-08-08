ExUnit.configure(seed: 0)
ExUnit.start()
Drill.Test.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Drill.Test.Repo, :manual)
