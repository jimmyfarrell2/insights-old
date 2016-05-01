defmodule Insights.PageController do
  use Insights.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
