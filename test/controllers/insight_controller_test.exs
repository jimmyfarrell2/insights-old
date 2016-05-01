defmodule Insights.InsightControllerTest do
  use Insights.ConnCase

  alias Insights.Insight
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, insight_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing insights"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, insight_path(conn, :new)
    assert html_response(conn, 200) =~ "New insight"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, insight_path(conn, :create), insight: @valid_attrs
    assert redirected_to(conn) == insight_path(conn, :index)
    assert Repo.get_by(Insight, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, insight_path(conn, :create), insight: @invalid_attrs
    assert html_response(conn, 200) =~ "New insight"
  end

  test "shows chosen resource", %{conn: conn} do
    insight = Repo.insert! %Insight{}
    conn = get conn, insight_path(conn, :show, insight)
    assert html_response(conn, 200) =~ "Show insight"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, insight_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    insight = Repo.insert! %Insight{}
    conn = get conn, insight_path(conn, :edit, insight)
    assert html_response(conn, 200) =~ "Edit insight"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    insight = Repo.insert! %Insight{}
    conn = put conn, insight_path(conn, :update, insight), insight: @valid_attrs
    assert redirected_to(conn) == insight_path(conn, :show, insight)
    assert Repo.get_by(Insight, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    insight = Repo.insert! %Insight{}
    conn = put conn, insight_path(conn, :update, insight), insight: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit insight"
  end

  test "deletes chosen resource", %{conn: conn} do
    insight = Repo.insert! %Insight{}
    conn = delete conn, insight_path(conn, :delete, insight)
    assert redirected_to(conn) == insight_path(conn, :index)
    refute Repo.get(Insight, insight.id)
  end
end
