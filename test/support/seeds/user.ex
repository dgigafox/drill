defmodule Drill.Test.UserSeed do
  @moduledoc false
  use Drill, key: :users, source: Drill.Test.User

  alias Faker.Person

  @impl true
  def constraints, do: [:email]

  @impl true
  def factory do
    %{
      email: Faker.Internet.email(),
      first_name: Person.first_name(),
      last_name: Person.last_name()
    }
  end

  @impl true
  def run(%Drill.Context{}) do
    [
      build(email: "email1@example.com"),
      build(email: "email2@example.com"),
      build(email: "email3@example.com")
    ]
  end
end
