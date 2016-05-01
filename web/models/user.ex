defmodule Insights.User do
  use Insights.Web, :model
  alias Passport.Password

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :insights, Insights.Insight, foreign_key: :author_id

    timestamps
  end

  @required_fields ~w(username email password)
  @optional_fields ~w(first_name last_name)

  def changeset(model, params \\ :empty) do model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:email, min: 1, max: 150)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def registration_changeset(model, params) do model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Password.hash(pass))
        _ ->
          changeset
    end
  end

end
