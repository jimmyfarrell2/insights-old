defmodule Insights.Repo.Migrations.CreateInsight do
  use Ecto.Migration

  def change do
    create table(:insights, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :body, :string, size: 65000
      add :category, :string
      add :tags, {:array, :string}, default: []
      add :published_at, :datetime
      add :author_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps
    end
    create index(:insights, [:author_id])
    create index(:insights, [:title])
    create index(:insights, [:category])
    create index(:insights, [:tags])

  end
end
