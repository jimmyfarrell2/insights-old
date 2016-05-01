defmodule Insights.InsightController do
  use Insights.Web, :controller
  import Ecto.Query
  alias Insights.Insight
  alias Insights.User

  plug :scrub_params, "insight" when action in [:create, :update]
  plug :verify_authorization, "verify authorization" when action in [:new]

  def index(conn, %{"user_username" => username}) do
    insights =
      Insight
      |> Repo.all
      |> Repo.preload(:author)
      |> Enum.filter(fn(insight) ->
        %{author: %{username: u}} = insight
        u == username
      end)

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
    username = conn |> Map.get(:assigns) |> Map.get(:current_user) |> Map.get(:username)
    author_id = User |> where(username: ^username) |> Repo.one |> Map.get(:id)
    insight_params = Map.put(insight_params, "author_id", author_id)
    changeset = Insight.changeset(%Insight{}, insight_params)

    case Repo.insert(changeset) do
      {:ok, _insight} ->
        conn
        |> put_flash(:info, "Insight created successfully.")
        |> redirect(to: insight_path(conn, :index))
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
    render(conn, "edit.html", insight: insight, changeset: changeset)
  end

  def update(conn, %{"id" => id, "insight" => insight_params}) do
    insight = Repo.get!(Insight, id)
    changeset = Insight.changeset(insight, insight_params)

    case Repo.update(changeset) do
      {:ok, insight} ->
        conn
        |> put_flash(:info, "Insight updated successfully.")
        |> redirect(to: insight_path(conn, :show, insight))
      {:error, changeset} ->
        render(conn, "edit.html", insight: insight, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    insight = Repo.get!(Insight, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(insight)

    conn
    |> put_flash(:info, "Insight deleted successfully.")
    |> redirect(to: insight_path(conn, :index))
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
