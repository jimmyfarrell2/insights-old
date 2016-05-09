defmodule Insights.InsightController do
  use Insights.Web, :controller

  import Ecto.Query

  alias Insights.Insight
  alias Insights.User
  alias Insights.Version

  #plug :scrub_params, "insight" when action in [:create, :update]
  plug :verify_authorization, "verify authorization" when action in [:new]

  def index(conn, %{"user_username" => username}) do
    insights =
      User
      |> where(username: ^username)
      |> preload(:insights)
      |> Repo.one
      |> Map.get(:insights)
      |> Repo.preload(:author)
    render(conn, "index.html", insights: insights)
  end

  def index(conn, _params) do
    insights = Insight |> Repo.all |> Repo.preload(:author)
    render(conn, "index.html", insights: insights)
  end

  def new(conn, _params) do
    changeset = Insight.changeset(%Insight{})
    render(conn, "new.html", changeset: changeset, categories: categories)
  end

  def create(conn, %{"insight" => insight_params}) do
    %{assigns: %{current_user: %{username: username}}} = conn
    author_id = User |> where(username: ^username) |> Repo.one |> Map.get(:id)
    insight_params = Map.put(insight_params, "author_id", author_id)
    changeset = Insight.changeset(%Insight{}, insight_params)

    case Repo.insert(changeset) do
      {:ok, insight} ->
        conn
        |> put_flash(:info, "Insight created successfully.")
        |> redirect(to: user_insight_path(conn, :edit, username, insight))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, categories: categories)
    end
  end

  def show(conn, %{"id" => id}) do
    insight = Repo.get!(Insight, id) |> Repo.preload(:author)
    render(conn, "show.html", insight: insight)
  end

  def edit(conn, %{"id" => id}) do
    insight = Repo.get!(Insight, id)
    changeset = Insight.changeset(insight)
    render(conn, "edit.html", insight: insight, changeset: changeset, categories: categories)
  end

  def update(conn, %{"id" => id, "version" => %{"id" => version_id}}) do
    %{assigns: %{current_user: %{username: username}}} = conn
    insight = Repo.get!(Insight, id)
    version = Repo.get(Version, version_id)
    changeset = Insight.changeset(insight, %{body: version.body})
    insert_version(insight)
    case Repo.update(changeset) do
      {:ok, _insight} ->
        conn
        |> put_flash(:info, "Previous version restored.")
        |> redirect(to: user_insight_path(conn, :edit, username, insight))
      {:error, _changeset} ->
        conn
        |> put_flash(:info, "There was a problem restoring version.")
        |> redirect(to: user_insight_version_path(conn, :edit, username, insight, version))
    end
  end

  def update(conn, %{"id" => id, "insight" => insight_params}) do
    insight = Repo.get!(Insight, id)
    %{"body" => new_body} = insight_params
    unless insight.body == new_body, do: insert_version(insight)
    changeset = Insight.changeset(insight, insight_params)
    case Repo.update(changeset) do
      {:ok, _insight} -> conn |> send_resp(200, "")
      {:error, _changeset} -> conn |> send_resp(500, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    insight = Repo.get!(Insight, id)
    Repo.delete!(insight)
    conn
    |> put_flash(:info, "Insight deleted successfully.")
    |> redirect(to: insight_path(conn, :index))
  end

  defp insert_version(insight) do
    changeset = Version.changeset(%Version{}, %{insight_id: insight.id, body: insight.body, created_at: insight.updated_at})
    Repo.insert(changeset)
  end

  defp categories do
    ~w(Education Health/Fitness Technology)
  end

  defp verify_authorization(%{assigns: %{current_user: current_user}} = conn, _) do
    case current_user do
      nil -> conn |> put_flash(:error, "You are not logged in.") |> redirect(to: "/") |> halt
      _ -> conn
    end
  end
end
