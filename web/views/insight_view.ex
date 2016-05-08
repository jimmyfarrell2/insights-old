defmodule Insights.InsightView do
  use Insights.Web, :view
  alias Earmark.Options

  def md_to_html(md) do
    md |> Earmark.to_html(%Options{gfm: true, breaks: true}) |> raw
  end
end
