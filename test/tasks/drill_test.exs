defmodule Mix.Tasks.DrillTest do
  use ExUnit.Case, async: true
  alias Drill.Test.Repo
  alias Ecto.Adapters.SQL.Sandbox
  alias Mix.Tasks.Drill, as: DrillTask

  test "Mix.Tasks.Drill is a task" do
    assert Mix.Task.task?(DrillTask)
  end

  test "Mix.Tasks.Drill task name is task" do
    assert Mix.Task.task_name(DrillTask) == "drill"
  end

  describe "run/1" do
    setup do
      Sandbox.checkout(Repo)
      :ok
    end

    test "seeds the database" do
      Mix.Task.run("drill", ["--r", "NonExistingRepo"])

      assert [
               %{id: user1_id, email: "email1@example.com"},
               %{id: user2_id, email: "email2@example.com"},
               %{id: user3_id, email: "email3@example.com"}
             ] = Drill.Test.User |> Repo.all() |> Enum.sort_by(& &1.email)

      assert [
               %{id: post1_id, user_id: ^user1_id},
               %{id: post2_id, user_id: ^user2_id},
               %{id: post3_id, user_id: ^user3_id}
             ] =
               Drill.Test.Post
               |> Repo.all()
               |> Repo.preload(:user)
               |> Enum.sort_by(& &1.user.email)

      assert [
               %{user_id: ^user1_id, post_id: ^post1_id},
               %{user_id: ^user2_id, post_id: ^post2_id},
               %{user_id: ^user3_id, post_id: ^post3_id}
             ] =
               Drill.Test.Comment
               |> Repo.all()
               |> Repo.preload(:user)
               |> Enum.sort_by(& &1.user.email)
    end
  end
end
