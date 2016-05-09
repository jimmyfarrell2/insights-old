defmodule Insights.VersionController do
  use Insights.Web, :controller

  import Ecto.Query

  alias Earmark.Options
  alias Insights.Insight
  alias Insights.User
  alias Insights.Version

  def index(conn, %{"insight_id" => insight_id, "user_username" => username}) do
    insight = Insight |> where(id: ^insight_id) |> preload(:versions) |> Repo.one
    author = User |> where(username: ^username) |> Repo.one
    render(conn, "index.html", insight: insight, author: author)
  end

  def show(conn, %{"id" => id, "insight_id" => insight_id}) do
    version = Repo.get!(Version, id)
    insight = Repo.get!(Insight, insight_id) |> Repo.preload(:author)
    dir_path = Path.join([".", "diffs", "diff_#{insight_id}"]) |> Path.absname
    diff = get_diff(insight.body, version.body, dir_path)
    render(conn, "show.html", diff: diff, insight: insight, version: version,
     action: user_insight_path(conn, :update, insight.author.username, insight_id))
  end

  def delete(conn, %{"id" => id}) do
    version = Repo.get!(Version, id)
    Repo.delete!(version)
    send_resp(conn, :no_content, "")
  end

  defp get_diff(current, version, dir_path) do
    results = create_filepaths(dir_path) |> get_results(current, version)
    case results do
      {:ok, contents} -> contents
      {:error, reason} -> reason
    end
  end

  defp create_filepaths(dir_path) do
    timestamp = :calendar.local_time |> :calendar.datetime_to_gregorian_seconds
    unless File.exists?(dir_path), do: File.mkdir(dir_path)
    Enum.reduce(["curr", "ver", "diff"], %{}, fn(val, acc) ->
      Map.put(acc, val, Path.join(dir_path, "#{timestamp}-#{val}.html"))
    end)
  end

  defp markdown_to_html(markdowns) do
    markdowns
    |> Tuple.to_list
    |> Enum.reduce({}, &(&2 |> Tuple.append(Earmark.to_html(&1, %Options{gfm: true, breaks: true}))))
  end

  defp write_files({current_html, version_html}, %{"curr" => path_curr, "ver" => path_ver, "diff" => path_diff}) do
    File.write(path_curr, current_html)
    File.write(path_ver, version_html)
    System.cmd("java", ["-jar", Path.join([".", "lib", "daisydiff.jar"]), path_curr, path_ver, "--file=#{path_diff}"])
  end

  defp get_results(%{"diff" => path_diff} = paths, current, version) do
    for p <- Map.values(paths), do: File.touch(p)
    markdown_to_html({current, version}) |> write_files(paths)
    results = File.read(path_diff)
    for p <- Map.values(paths), do: File.rm(p)
    results
  end
end
