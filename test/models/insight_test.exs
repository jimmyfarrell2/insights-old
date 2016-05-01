defmodule Insights.InsightTest do
  use Insights.ModelCase

  alias Insights.Insight

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Insight.changeset(%Insight{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Insight.changeset(%Insight{}, @invalid_attrs)
    refute changeset.valid?
  end
end
