# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  ecto_repos: [MyApp.Repo]

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NCH8RTU2ebBzvaCyKq2Hx5kyWBSdMPVbxJt/BYGPF5WPwm7eJsCCjnWH6VxSq8ii",
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MyApp.PubSub,
  live_view: [signing_salt: "lv4E4ffH"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_cldr,
  default_locale: "en",
  default_backend: MyApp.Cldr,
  json_library: Jason

config :mavu_form,
  default_theme: :tw_material

config :mavu_snippets,
  langs: [l1: "en", l2: "de", l3: "it"]

config :mavu_form, :themes,
  tw_default: MyAppBe.TwVerticalInputTheme,
  tw_horizontal: MyAppBe.TwHorizontalInputTheme,
  tw_material: MyAppBe.TwMaterialInputTheme

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
