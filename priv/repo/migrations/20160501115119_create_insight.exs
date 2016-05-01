defmodule Insights.Repo.Migrations.CreateInsight do
  use Ecto.Migration

  def change do
    create table(:insights) do
      add :title, :string
      add :author_id, references(:users, on_delete: :nothing)
      add :current_version, :text

      timestamps
    end
    create index(:insights, [:author_id])

  end
end
