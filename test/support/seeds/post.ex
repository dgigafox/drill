defmodule Drill.Test.PostSeed do
  @moduledoc false
  use Drill, key: :posts, source: Drill.Test.Post
  alias Faker.Lorem

  @impl true
  def deps do
    [Drill.Test.UserSeed]
  end

  @impl true
  def factory do
    %{content: Lorem.paragraph()}
  end

  @impl true
  def run(%Drill.Context{seeds: %{users: [user1, user2, user3 | _]}}) do
    for user <- [user1, user2, user3] do
      seed(user_id: user.id)
    end
  end
end
