defmodule Drill.Demo.Repo.Migrations.AddUsersPostsAndCommentsForDemo do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      timestamps()
    end

    create table(:posts) do
      add(:content, :text)
      add(:user_id, references(:users))
    end

    create table(:comments) do
      add(:content, :text)
      add(:user_id, references(:users))
      add(:post_id, references(:posts))
    end
  end
end
