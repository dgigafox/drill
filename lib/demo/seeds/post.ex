defmodule Drill.Demo.PostSeed do
  use Drill, key: :posts, source: Drill.Demo.Post
  alias Faker.Lorem

  @impl true
  def deps do
    [Drill.Demo.UserSeed]
  end

  @impl true
  def run(%Drill.Context{seeds: %{users: [user1, user2, user3 | _]}}) do
    [
      %{
        content: Lorem.paragraph(),
        user_id: user1.id,
        inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      },
      %{
        content: Lorem.paragraph(),
        user_id: user2.id,
        inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      },
      %{
        content: Lorem.paragraph(),
        user_id: user3.id,
        inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }
    ]
  end
end
