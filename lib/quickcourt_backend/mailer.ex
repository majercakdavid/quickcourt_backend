defmodule QuickcourtBackend.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:quickcourt_backend, :mailgun_domain),
    key: Application.get_env(:quickcourt_backend, :mailgun_key)

  def send_update_status_email(email_address, claim_identifier) do
    send_email(
      to: email_address,
      from: "info@quickcourt.com",
      subject: "Claim expiration",
      text:
        "Dear user, \nyour claim " <>
          claim_identifier <>
          " has been delivered to the defendant more than 14 days ago." <>
          "\nIf you would like to proceed further in the process please login and update the status of the claim. \n\n\n Regards,\n Nicolaj and Quickcourt team!"
    )
  end
end
