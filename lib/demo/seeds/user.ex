defmodule Drill.Demo.UserSeed do
  @moduledoc false
  use Drill, key: :users, source: Drill.Demo.User

  alias Faker.Person

  @impl true
  def constraints, do: [:email]

  @impl true
  def run(%Drill.Context{}) do
    [
      %{
        email: "email1@example.com",
        first_name: Person.first_name(),
        last_name: Person.last_name()
      },
      %{
        email: "email2@example.com",
        first_name: Person.first_name(),
        last_name: Person.last_name()
      },
      %{
        email: "email3@example.com",
        first_name: Person.first_name(),
        last_name: Person.last_name()
      }
    ]
  end
end
