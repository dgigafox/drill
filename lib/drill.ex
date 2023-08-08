defmodule Drill do
  @moduledoc """
  Drill is an elixir seeder library inspired by [Seed Fu](https://github.com/mbleigh/seed-fu) and [Phinx](https://github.com/cakephp/phinx).

  ## Usage
  1. Create your seeder modules. The directory where the seeder modules should be located
   is described on [mix drill documentation](https://hexdocs.pm/drill/Mix.Tasks.Drill.html).

  In `my_app/priv/repo/seeds/user.exs`:

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

  In `my_app/priv/repo/seeds/post.exs`:

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

  2. Run `mix drill -r MyApp.Repo` in the terminal with your project root as the current working directory

  ## Installation
  Add `drill` to your list of dependencies in `mix.exs`:
  ```
  def deps do
    [
      {:drill, "~> 1.2"}
    ]
  end
  ```

  ## Configurations
  ### Timeout
  Default timeout is 600 seconds or 10 minutes. You may configure the task timeout in your config.exs file e.g.:
    config :drill, :timeout, 10_000

  ## `use Drill` options
  * `source` (required) - source is the schema module
  * `key` (required) - once the seeder module runs, the inserted result will be saved to `%Drill.Context{}.seeds[key]`.
  Drill.Context struct is passed to one of Drill's callback which is `run/1` to be discussed in the `Callbacks`
  section below.
  * `returning` (optional) - selects which fields to return. Defaults to true. See [Ecto.Repo.insert_all/3](https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert_all/3)

  ## Callbacks
  * `constraints/0` (optional) - returns a list of column names to verify for conflicts. If a conflict occurs all fields will
  just be updated. This prevents insertion of new records based on the constraints when drill is run again.
  * `on_conflict/0` (optional) - returns the conflict strategy. The default is `:replace_all`. Only works when `constraints/0`
  returns a non-empty list. See [Ecto.Repo.insert_all/4](https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert_all/4) for more details.
  * `deps/0` (optional) - returns a list of seeder modules that should be run prior to the current seeder
  * `factory/0` (optional) - set default values for the fields. This is used when you call `seed/1` from the seeder module.
  * `run/1` (required) - returns a list of seeds (a call to `Drill.seed/1` function or anything you want to include in the context seed).
  Autogenerated fields such as `:inserted_at` or `:updated_at` may not be defined. The first argument is the `Drill.Context` struct, which
  you can use to get the inserted records from previously run seeder modules (see Usage section above).

  ## Command line options
  * `--repo` - specifies the repository to use
  * `--seeds-path` - overrides the default seeds path
  * Command line options for `mix app.start` documented [here](https://hexdocs.pm/mix/1.15.2/Mix.Tasks.App.Start.html#module-command-line-options)
  """
  alias Drill.Context
  alias Drill.Seed

  @callback deps() :: [atom()]
  @callback run(Context.t()) :: [any()]
  @callback factory() :: map()
  @callback constraints() :: [atom()] | {:unsafe_fragment, binary()}
  @callback on_conflict() ::
              :raise
              | :nothing
              | :replace_all
              | {:replace_all_except, [atom()]}
              | {:replace, [atom()]}

  defmacro __using__(opts \\ []) when is_list(opts) do
    source = Keyword.fetch!(opts, :source)
    key = Keyword.fetch!(opts, :key)
    returning = Keyword.get(opts, :returning, true)

    quote do
      @behaviour Drill

      def context_key, do: unquote(key)
      def schema, do: unquote(source)
      def returning, do: unquote(returning)

      @impl true
      def constraints, do: []

      @impl true
      def on_conflict, do: :replace_all

      @impl true
      def factory, do: %{}

      @impl true
      def deps, do: []

      def seed(attrs \\ []), do: Seed.new(__MODULE__, attrs)

      defoverridable deps: 0, constraints: 0, on_conflict: 0, factory: 0
    end
  end
end
