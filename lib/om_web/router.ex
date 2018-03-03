defmodule OmWeb.Router do
  use OmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    ##custom plugs controllers/auth.ex
    plug Om.Auth, repo: Om.Repo
  end


  pipeline :api do
    plug :accepts, ["json"]

  resources "/orbs", OrbController, except: [:new, :edit]
  end

  scope "/", OmWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/login", PageController, :create
    get "/logout", PageController, :logout

    get "/blob", PageController, :blob
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", OmWeb do
  #   pipe_through :api
  # end
end
