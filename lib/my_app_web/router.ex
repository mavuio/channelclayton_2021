defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  import MyAppBe.BeUserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_be_user

    plug(Cldr.Plug.SetLocale,
      apps: :cldr,
      cldr: MyApp.Cldr,
      from: [:path],
      param: "lang",
      default: "en"
    )

    plug(ElixirWeb.Plugs.LangAssign)
  end

  pipeline :require_belayout do
    plug(:put_root_layout, {MyAppBe.BeLayoutView, :be_root})
    plug(:put_layout, {MyAppBe.BeLayoutView, :be_app})
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", StartpageController, :startpage
    get "/", RssController, :startpage
    get "/episode/:episode_num", RssController, :episode_json
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
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
      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
    end
  end

  ## Backend routes

  scope "/be", MyAppBe do
    pipe_through :browser
    pipe_through :require_belayout
    pipe_through :require_authenticated_be_user

    live("/", BackendIndexLive, :index)

    # live("/texts", SnippetLive.Index, :index)
    # live("/texts/new", SnippetLive.Index, :new)
    # live("/texts/:id/edit", SnippetLive.Index, :edit)
    # live("/texts/:id/modify", SnippetLive.Modify, :modify)
    # live("/texts/:id/modify/:path/append", SnippetLive.Modify, :append)
    # live("/texts/:id/modify/:path/edit/:uid", SnippetLive.Modify, :edit)

    # live("/texts/:id/tweak", SnippetLive.Tweak, :tweak)
    # live("/texts/:id/tweak/:path/append", SnippetLive.Tweak, :append)
    # live("/texts/:id/tweak/:path/edit/:uid", SnippetLive.Tweak, :edit)
    # live("/texts/:id/tweak/:path/edit_list_json", SnippetLive.Tweak, :edit_list_json)

    # live("/texts/:id", SnippetLive.Show, :show)
    # live("/texts/:id/show/edit", SnippetLive.Show, :edit)
  end

  scope "/be", MyAppBe do
    pipe_through [:browser, :require_belayout, :redirect_if_be_user_is_authenticated]

    get "/be_users/register", BeUserRegistrationController, :new
    post "/be_users/register", BeUserRegistrationController, :create
    get "/be_users/log_in", BeUserSessionController, :new
    post "/be_users/log_in", BeUserSessionController, :create
    get "/be_users/reset_password", BeUserResetPasswordController, :new
    post "/be_users/reset_password", BeUserResetPasswordController, :create
    get "/be_users/reset_password/:token", BeUserResetPasswordController, :edit
    put "/be_users/reset_password/:token", BeUserResetPasswordController, :update
  end

  scope "/be", MyAppBe do
    pipe_through [:browser, :require_belayout, :require_authenticated_be_user]

    get "/be_users/settings", BeUserSettingsController, :edit
    put "/be_users/settings", BeUserSettingsController, :update
    get "/be_users/settings/confirm_email/:token", BeUserSettingsController, :confirm_email
    live("/be_users/list", BeUserUi.BeUserLive, :index)
    live("/snippets/list", SnippetsUi.SnippetsLive, :index)
    live("/episodes/list", EpisodeLive, :index)
    live("/seasons/list", SeasonLive, :index)
  end

  scope "/be", MyAppBe do
    pipe_through [:browser, :require_belayout]

    delete "/be_users/log_out", BeUserSessionController, :delete
    get "/be_users/confirm", BeUserConfirmationController, :new
    post "/be_users/confirm", BeUserConfirmationController, :create
    get "/be_users/confirm/:token", BeUserConfirmationController, :confirm
  end
end
