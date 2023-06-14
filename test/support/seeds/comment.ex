defmodule Drill.Test.CommentSeed do
  @moduledoc false
  use Drill, key: :comment, source: Drill.Test.Comment
  alias Faker.Lorem

  @impl true
  def deps do
    [Drill.Test.PostSeed]
  end

  @impl true
  def factory do
    %{content: Lorem.paragraph()}
  end

  @impl true
  def run(%Drill.Context{
        seeds: %{posts: [post1, post2, post3 | _], users: [user1, user2, user3 | _]}
      }) do
    [
      seed(user_id: user1.id, post_id: post1.id),
      seed(user_id: user2.id, post_id: post2.id),
      seed(user_id: user3.id, post_id: post3.id)
    ]
  end
end
