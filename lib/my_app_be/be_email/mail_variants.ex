defmodule MyAppBe.BeEmail.MailVariants do
  use Bamboo.Phoenix, view: MyAppBe.BeEmailView

  import MavuUtils, warn: false

  defp base_email do
    new_email()
    |> from(default_sender())
    # This will use the "email.html.eex" file as a layout when rendering html emails.
    # Plain text emails will not use a layout unless you use `put_text_layout`
    |> put_html_layout({MyAppBe.BeLayoutView, "be_email_root.html"})
  end

  def generic_text_mail(%{text: text, subject: subject} = mail_content) when is_binary(text) do
    base_email()
    |> subject(subject)
    |> render(:generic_text_mail, mail_content |> Map.to_list())
  end

  def default_sender() do
    {"server", "server@mavu.io"}
  end
end
