defmodule SuperIssuerWeb.Router do
  use SuperIssuerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {SuperIssuerWeb.LayoutView, :root}
  end

  pipeline :require_auth do
    plug(SuperIssuerWeb.Middleware.RequireAuth)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SuperIssuerWeb do
    pipe_through :browser
    # index
    get "/", PageController, :index
    post "/", PageController, :index
    # user pathes
    # user new then create
    resources "/user/registrations", UserController, only: [:create, :new]
    get "/user/sign-in", SessionController, :new
    post "/user/sign-in", SessionController, :create
    get "/user", UserController, :index
    get "/credential/credential", CredentialController, :index

    live "/live/clock", ClockLive
    live "/live/credential", CredentialLive
  end

  scope "/login_yet", SuperIssuerWeb do
    pipe_through([:browser, :require_auth])
    get "/test", TestController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", SuperIssuerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SuperIssuerWeb.Telemetry
    end
  end
end
