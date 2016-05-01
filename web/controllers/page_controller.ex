defmodule Insights.PageController do
  use Insights.Web, :controller

  def index(conn, _params) do
    %{assigns: %{current_user: current_user}} = conn
    render(conn, "index.html", current_user: current_user)
  end
end
