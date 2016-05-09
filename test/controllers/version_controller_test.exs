defmodule Insights.VersionControllerTest do
  use Insights.ConnCase

  alias Insights.Version
  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, version_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    version = Repo.insert! %Version{}
    conn = get conn, version_path(conn, :show, version)
    assert json_response(conn, 200)["data"] == %{"id" => version.id,
      "body" => version.body,
      "insight_id" => version.insight_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, version_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, version_path(conn, :create), version: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Version, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, version_path(conn, :create), version: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    version = Repo.insert! %Version{}
    conn = put conn, version_path(conn, :update, version), version: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Version, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    version = Repo.insert! %Version{}
    conn = put conn, version_path(conn, :update, version), version: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    version = Repo.insert! %Version{}
    conn = delete conn, version_path(conn, :delete, version)
    assert response(conn, 204)
    refute Repo.get(Version, version.id)
  end
end
