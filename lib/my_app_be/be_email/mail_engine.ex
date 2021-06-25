defmodule MyAppBe.BeEmail.MailEngine do
  @moduledoc false

  alias MyAppBe.BeEmail.BambooMailer
  alias MyAppBe.BeEmail.MailVariants
  import Bamboo.Email

  require Ecto.Query

  def send_generic_text_mail(
        %{text: text, subject: subject} = _mail_content,
        recipient,
        _opts \\ []
      )
      when is_binary(text) and is_binary(recipient) do
    MailVariants.generic_text_mail(%{text: text, subject: subject})
    |> to([recipient])
    |> BambooMailer.deliver_now()

    # returns {:ok, %Bamboo.Email{}} on success
  end
end
