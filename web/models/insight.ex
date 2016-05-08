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

  @required_fields ~w(author_id title)
  @optional_fields ~w(body category tags published_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> strip_unsafe_body(params)
  end

  defp strip_unsafe_body(model, %{body: nil}) do
    model
  end

  defp strip_unsafe_body(model, %{body: body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    model |> put_change(:body, clean_body)
  end

  defp strip_unsafe_body(model, _params) do
    model
  end
end
