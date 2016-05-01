defmodule Insights.Insight do
  use Insights.Web, :model

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "insights" do
    field :title, :string
    field :body, :string
    field :category, :string
    field :tags, {:array, :string}
    field :published_at, Ecto.DateTime
    belongs_to :author, Insights.User

    timestamps
  end

  @required_fields ~w(author_id)
  @optional_fields ~w(title body category tags published_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
