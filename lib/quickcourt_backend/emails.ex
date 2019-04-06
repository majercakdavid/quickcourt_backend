defmodule QuickcourtBackend.Email do
  import Bamboo.Email

  @from "info@quickcourt.com"

  def send_warning_letter_claimant(claim, warning_letter_pdf) do
    new_email(
      to: claim.claimant_email,
      from: @from,
      subject: "Warning letter confirmation",
      text_body:
        "Dear user, \nyour claim " <>
          claim.case_number <>
          " has been created and the warning letter was sent to the defendant." <>
          "\nThank you for using our services. \n\n\n Regards,\n Nicolaj and Quickcourt team!"
    )
    |> put_attachment(%Bamboo.Attachment{
      filename: "quickcourt_warning_letter_" <> claim.case_number <> ".pdf",
      data: warning_letter_pdf
    })
    |> QuickcourtBackend.Mailer.deliver_now()
  end

  def send_warning_letter_defendant(claim, warning_letter_pdf) do
    new_email(
      to: claim.defendant_email,
      from: @from,
      subject: "Warning letter",
      text_body:
        "To whom it may concern, \ncustomer created a claim agains a product or a service he received." <>
          "\nYou can find more details in the attached pdf file." <>
          "\nWe are pleased to inform you that if you will nor proceed the claim will be automatically escalated to the official EU claim." <>
          "\n\n\n Regards,\n Nicolaj and Quickcourt team!"
    )
    |> put_attachment(%Bamboo.Attachment{
      filename: "quickcourt_warning_letter_" <> claim.case_number <> ".pdf",
      data: warning_letter_pdf
    })
    |> QuickcourtBackend.Mailer.deliver_now()
  end

  def send_update_status_email(email_address, claim_identifier) do
    new_email(
      to: email_address,
      from: @from,
      subject: "Claim expiration",
      text_body:
        "Dear user, \nyour claim " <>
          claim_identifier <>
          " has been delivered to the defendant more than 14 days ago." <>
          "\nIf you would like to proceed further in the process please login and update the status of the claim. \n\n\n Regards,\n Nicolaj and Quickcourt team!"
    )
    |> QuickcourtBackend.Mailer.deliver_now()
  end
end
