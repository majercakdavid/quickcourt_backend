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
      add :agreement_type, :string
      add :agreement_type_issue, :string
      add :circumstance_invoked, :string
      add :first_resolution, :string
      add :second_resolution, :string
      add :purchase_place, :string, default: "online"
      add :purchase_date, :utc_datetime
      add :delivery_place, :string, default: "online"
      add :delivery_date, :utc_datetime
      add :lack_discovery_date, :utc_datetime

      add :claim_for_money, :boolean, default: false
      add :amount, :float, default: nil
      add :currency, :string, default: nil

      timestamps()
    end
  end
end
