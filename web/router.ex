defmodule Insights.Router do
  use Insights.Web, :router
  use Passport

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Insights do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/forget-password", PasswordController, :forget_password
    post "/reset-password", PasswordController, :reset_password

    resources "/users", UserController, param: "username", except: [:new] do
      resources "/insights", InsightController, param: "username", only: [:index]
    end

    resources "/insights", InsightController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Insights do
  #   pipe_through :api
  # end
end
