defmodule Insights.Repo.Migrations.CreateVersion do
  use Ecto.Migration

  def change do
    create table(:versions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :string, size: 65000
      add :created_at, :datetime
      add :insight_id, references(:insights, type: :uuid, on_delete: :delete_all)

      timestamps
    end
    create index(:versions, [:insight_id])

  end
end
