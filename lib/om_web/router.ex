defmodule OmWeb.Router do
  use OmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Om.Auth, repo: Om.Repo
  end


  pipeline :api do
    plug :accepts, ["json"]

  resources "/modos", ModoController, except: [:new, :edit]
  resources "/todos", TodoController, except: [:new, :edit]
  end

  scope "/", OmWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/login", PageController, :create
    get "/logout", PageController, :logout

    get "/chat", PageController, :chat
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", OmWeb do
  #   pipe_through :api
  # end
end
