defmodule Insights.Insight do
  use Insights.Web, :model

  schema "insights" do
    field :title, :string
    field :current_version, :string
    belongs_to :author, Insights.User

    timestamps
  end

  @required_fields ~w(title author_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(insight, params \\ :empty) do
    insight
    |> cast(params, @required_fields, @optional_fields)
  end
end
