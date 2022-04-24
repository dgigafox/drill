defmodule Drill.Demo.CommentSeed do
  use Drill, key: :comment, source: Drill.Demo.Comment
  alias Faker.Lorem

  @impl true
  def deps do
    [Drill.Demo.PostSeed]
  end

  @impl true
  def run(%Drill.Context{
        seeds: %{posts: [post1, post2, post3 | _], users: [user1, user2, user3 | _]}
      }) do
    [
      %{
        content: Lorem.paragraph(),
        user_id: user1.id,
        post_id: post1.id
      },
      %{
        content: Lorem.paragraph(),
        user_id: user2.id,
        post_id: post2.id
      },
      %{
        content: Lorem.paragraph(),
        user_id: user3.id,
        post_id: post3.id
      }
    ]
  end
end
