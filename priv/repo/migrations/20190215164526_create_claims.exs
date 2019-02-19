defmodule QuickcourtBackend.Repo.Migrations.CreateClaims do
  use Ecto.Migration

  def change do
    create table(:claims) do
      add :is_business, :boolean, default: false, null: false
      add :claimant_country_id, references(:countries)
      add :defendant_country_id, references(:countries)
      add :claimant_address, :string
      add :defendant_address, :string
      add :agreement_type_id, references(:agreement_types)
      add :issue_type_id, references(:issue_types)
      # add :resolution_type_id, references(:resolution_types)
      add :purchase_place, :string, default: "online"
      add :purchase_date, :utc_datetime
      add :delivery_place, :string, default: "online"
      add :delivery_date, :utc_datetime
      add :lack_discovery_date, :utc_datetime

      timestamps()
    end
  end
end
