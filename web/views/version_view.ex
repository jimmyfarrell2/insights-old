defmodule Insights.VersionView do
  use Insights.Web, :view
  use Timex

  def format_date(datetime) do
    Timex.format!(datetime, "%b %d, %Y // %I:%M %p", :strftime)
  end

  def cleanup_diff(html) do
    html
    |> String.replace(~r/<html>[\d\D]*<\/div>\n/, "")
    |> String.replace(~r/\n<\/body>\n<\/html>\n/, "")
  end
end
