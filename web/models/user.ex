defmodule Insights.User do
  use Insights.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :password, :string
    field :email, :string
    has_many :insights, Insights.Insight, foreign_key: :author_id

    timestamps
  end

  @required_fields ~w(username password email)
  @optional_fields ~w(first_name last_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(user, params \\ :empty) do
    user
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/.+@.+/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
