defmodule Insights.VersionTest do
  use Insights.ModelCase

  alias Insights.Version

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Version.changeset(%Version{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Version.changeset(%Version{}, @invalid_attrs)
    refute changeset.valid?
  end
end
