defmodule QuickcourtBackend.Repo.Migrations.CreateClaims do
  use Ecto.Migration

  def change do
    create table(:claims) do
      add :case_number, :string, primary_key: true
      add :is_business, :boolean, default: false, null: false
      add :claimant_name, :string
      add :claimant_surname, :string
      add :defendant_company_name, :string
      add :claimant_city, :string
      add :defendant_city, :string
      add :claimant_zip, :string
      add :defendant_zip, :string
      add :claimant_country_id, references(:countries)
      add :defendant_country_id, references(:countries)
      add :claimant_address, :string
      add :defendant_address, :string
      add :claimant_email, :string
      add :defendant_email, :string
      add :claimant_phone, :string
      add :defendant_phone, :string
      add :agreement_type_label, :string
      add :agreement_type_issue_label, :string
      add :circumstances_invoked_label, :string
      add :first_resolution_label, :string
      add :second_resolution_label, :string
      add :purchase_country_id, references(:countries), default: nil
      add :purchase_date, :utc_datetime
      add :delivery_country_id, references(:countries), default: nil
      add :delivery_date, :utc_datetime

      add :lack_discovery_date, :utc_datetime
      add :contract_cancellation_date, :utc_datetime
      add :goods_return_date, :utc_datetime
      add :issue_description, :text
      add :type_of_service_or_goods, :string

      add :damages_description, :text
      add :species_damages_description, :text

      add :claim_for_money, :boolean, default: false
      add :amount, :float, default: nil
      add :currency, :string, default: nil

      add :claim_status_id, references(:claim_statuses)
      add :warning_expiration_email_sent_on, :utc_datetime
      add :user_id, references(:users)

      timestamps()
    end
  end
end
