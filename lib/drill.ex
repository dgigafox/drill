defmodule Drill do
  @moduledoc """
  Drill is an elixir seeder library inspired by [Seed Fu](https://github.com/mbleigh/seed-fu) and [Phinx](https://github.com/cakephp/phinx).

  ## Usage
  1. Create your seeder modules. The directory where the seeder modules are located
  does not matter as long as it has `use Drill, ...`.

  In `my_app/lib/seeds/user.ex`:

  ```
  defmodule MyApp.Seeds.User do
    use Drill, key: :users, source: MyApp.Accounts.User

    def factory do
      %{
        first_name: Person.first_name(),
        last_name: Person.last_name()
      }
    end

    def run(_context) do
      [
        seed(email: "email1@example.com"),
        seed(email: "email2@example.com"),
        seed(email: "email3@example.com")
      ]
    end
  end
  ```

  In `my_app/lib/seeds/post.ex`:

  ```
  defmodule MyApp.Seeds.Post do
    use Drill, key: :posts, source: MyApp.Blogs.Post
    alias Faker.Lorem

    def deps do
      [MyApp.Seeds.User]
    end

    def factory do
      %{content: Lorem.paragraph()}
    end

    def run(%Drill.Context{seeds: %{users: [user1, user2, user3 | _]}}) do
      [
        seed(user_id: user1.id),
        seed(user_id: user2.id),
        seed(user_id: user3.id)
      ]
    end
  end
  ```

  2. Configure drill by adding the name of your application. This will let drill know which application
  contains the seeder modules.
  In `my_app/config/config.exs`:
  ```
  config :drill, :otp_app, :my_app
  ```

  3. Run `mix drill --r MyApp.Repo` in the terminal with your project root as the current working directory

  ## Installation
  This project is not yet published on [Hex](https://hex.pm/packages) so for the meantime you can add it to
  the list of dependencies in mix.exs as a github path:
  ```
  def deps do
    [
      {:drill, git: "git@github.com:dgigafox/drill.git"}
    ]
  end
  ```

  ## `use Drill` options
  * `source` - source is the schema module
  * `key` - once the seeder module runs, the inserted result will be saved to `%Drill.Context{}.seeds[key]`.
  Drill.Context struct is passed to one of Drill's callback which is `run/1` to be discussed in the `Callback`
  section below.

  ## Callbacks
  * `constraints/0` (optional) - returns a list of column names to verify for conflicts. If a conflict occurs all fields will
  just be updated. This prevents insertion of new records based on the constraints when drill is run again.
  * `deps/0` (optional) - returns a list of seeder modules that should be run prior to the current seeder
  * `run/1` (required) - returns a list of maps which keys are fields of the `:source` schema. Autogenerated fields
  such as `:inserted_at` or `:updated_at` may not be defined. The first argument is the `Drill.Context` struct, which
  you can use to get the inserted records from previously run seeder modules (see Usage section above).
  * `factory/0` (required) - set default values for the fields. This is used when you call `build/1` from the seeder module.
  """
  alias Drill.Context
  alias Drill.Seed

  @callback deps() :: [atom()]
  @callback run(Context.t()) :: [Seed.t()]
  @callback factory() :: map()
  @callback constraints() :: [atom()]

  defmacro __using__(opts \\ []) when is_list(opts) do
    source = Keyword.fetch!(opts, :source)
    key = Keyword.fetch!(opts, :key)

    quote do
      @behaviour Drill

      def context_key, do: unquote(key)
      def schema, do: unquote(source)

      @impl true
      def constraints, do: []

      @impl true
      def deps, do: []

      def autogenerate do
        for {fields, {func, name, args}} <- schema().__schema__(:autogenerate),
            field <- fields,
            into: %{} do
          {field, apply(func, name, args)}
        end
      end

      def seed(attrs \\ []), do: Seed.new(__MODULE__, attrs)

      defoverridable deps: 0, constraints: 0
    end
  end

  def build_entries(seeder, ctx) do
    ctx
    |> seeder.run()
    |> Seed.to_entries()
  end
end
