defmodule OmWeb.Router do
  use OmWeb, :router
  use Coherence.Router         # Add this

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    ##custom plugs controllers/auth.ex
    plug Om.Auth, repo: Om.Repo

#    plug Coherence.Authentication.Session  # Add this

  end

  # Add this block
  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end


  pipeline :api do
    plug :accepts, ["json"]

  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end


  scope "/manage", OmWeb do
    pipe_through :browser # Use the default browser stack

    resources "/videos", VideoController
  end
  scope "/", OmWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/login", PageController, :create
    get "/logout", PageController, :logout



    post "/sendjob", PageController, :sendjob
    get "/blob", PageController, :blob
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
  end

#  scope "/", OmWeb do
#    pipe_through :protected
#
#    # add protected resources below
##    resources "/privates", MyProjectWeb.PrivateController
#  end

  # Other scopes may use custom stacks.
  # scope "/api", OmWeb do
  #   pipe_through :api
  # end
end
