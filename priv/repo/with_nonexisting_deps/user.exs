defmodule Drill.Test.NonExistingDeps.UserSeed do
  @moduledoc false
  use Drill, key: :users, source: Drill.Test.User

  alias Faker.Person

  @impl true
  def constraints, do: [:email]

  @impl true
  def deps, do: [Drill.Test.NonExistingDep]

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
      seed(email: "email1@example.com"),
      seed(email: "email2@example.com"),
      seed(email: "email3@example.com")
    ]
  end
end
