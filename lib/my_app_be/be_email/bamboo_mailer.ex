defmodule MyAppBe.BeEmail.BambooMailer do
  use Bamboo.Mailer, otp_app: :my_app

  # local BambooMailer
  def absolutize_url(url) when is_binary(url) do
    url
    # |> String.replace_prefix("http:", "https:")
    # |> String.replace(~r(:\d\d\d\d/), "/")
  end
end
