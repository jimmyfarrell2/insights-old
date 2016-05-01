defmodule Insights.Router do
  use Insights.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Insights do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, param: "username" do
      resources "/insights", InsightController, param: "username", only: [:index]
    end
    resources "/insights", InsightController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Insights do
  #   pipe_through :api
  # end
end
