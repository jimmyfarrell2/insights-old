defmodule Insights.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string
      add :email, :string, null: false
      add :password_hash, :string

      timestamps
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
