defmodule QuickcourtBackend.ClaimStatusUpdater do
  use Task

  alias QuickcourtBackend.Court
  alias QuickcourtBackend.Email

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    receive do
    after
      43_200_000 ->
        update_status()
        poll()
    end
  end

  def update_status() do
    expired_claims = Court.expired_warning_claims()

    Enum.each(expired_claims, fn claim ->
      Email.send_update_status_email(claim.claimant_email, claim.case_number)
      Court.update_claim(claim, %{warning_expiration_email_sent_on: DateTime.utc_now()})
    end)
  end
end
