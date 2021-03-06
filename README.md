# Drill

**Seed data handling for Elixir**

Drill is an elixir seeder library inspired by [Seed Fu](https://github.com/mbleigh/seed-fu) and [Phinx](https://github.com/cakephp/phinx).

## Usage

1. Create your seeder modules. The directory where the seeder modules are located
   does not matter as long as it has `use Drill, ...`.

In `my_app/lib/seeds/user.ex`:

```elixir
defmodule MyApp.Seeds.User do
  use Drill, key: :users, source: MyApp.Accounts.User

  def run(_context) do
    [
      %{
        email: "user1@example.com",
        first_name: "John",
        last_name: "Smith"
      },
      ...
    ]
  end
end
```

In `my_app/lib/seeds/post.ex`:

```elixir
defmodule MyApp.Seeds.Post do
  use Drill, key: :posts, source: MyApp.Blogs.Post

  def deps do
    [MyApp.Seeds.User]
  end

  def run(%Drill.Context{seeds: %{users: [user1, user2, user3 | _]}}) do
    [
      %{
        content: Lorem.paragraph(),
        user_id: user1.id
      },
      ...
    ]
  end
end
```

2. Configure drill by adding the name of your application. This will let drill know which application
   contains the seeder modules.
   In `my_app/config/config.exs`:

```elixir
config :drill, :otp_app, :my_app
```

3. Run `mix drill --r MyApp.Repo` in the terminal with your project root as the current working directory

## Installation

Drill is available on [Hex](https://hex.pm/packages).

To add it to a mix project, just add a line like this in your deps function in mix.exs:

```elixir
def deps do
  [
    {:drill, "~> 0.1", only: [:dev, :test]},
  ]
end
```

## `use Drill` options

- `source` - source is the schema module
- `key` - once the seeder module runs, the inserted result will be saved to `%Drill.Context{}.seeds[key]`.
  Drill.Context struct is passed to one of Drill's callback which is `run/1` to be discussed in the `Callback`
  section below.

## Callbacks

- `constraints/0` (optional) - returns a list of column names to verify for conflicts. If a conflict occurs all fields will
  just be updated. This prevents insertion of new records based on the constraints when drill is run again.
- `deps/0` (optional) - returns a list of seeder modules that should be run prior to the current seeder
- `run/1` (required) - returns a list of maps which keys are fields of the `:source` schema. Autogenerated fields
  such as `:inserted_at` or `:updated_at` may not be defined. The first argument is the `Drill.Context` struct, which
  you can use to get the inserted records from previously run seeder modules (see Usage section above).

## Caveat

Can only be used on Postgres database for now

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/drill](https://hexdocs.pm/drill).
