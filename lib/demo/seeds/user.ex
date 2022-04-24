defmodule Drill.Demo.UserSeed do
  use Drill, key: :users, source: Drill.Demo.User

  alias Faker.{
    Internet,
    Person
  }

  @impl true
  def constraints, do: [:email]

  @impl true
  def run(%Drill.Context{}) do
    [
      %{
        email: Internet.email(),
        first_name: Person.first_name(),
        last_name: Person.last_name()
      },
      %{
        email: Internet.email(),
        first_name: Person.first_name(),
        last_name: Person.last_name()
      },
      %{
        email: Internet.email(),
        first_name: Person.first_name(),
        last_name: Person.last_name()
      }
    ]
  end
end
