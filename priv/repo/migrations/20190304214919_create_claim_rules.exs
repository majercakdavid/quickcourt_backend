defmodule QuickcourtBackend.Repo.Migrations.CreateClaimRules do
  use Ecto.Migration

  def change do
    create table(:claim_rules) do
      add :agreement_type, :string
      add :agreement_type_issue, :string
      add :claimant_description, :text
      add :defendant_description, :text
      add :circumstances_invoked_code, :string
      add :circumstances_invoked, :string
      add :first_resolution_code, :string
      add :first_resolution, :string
      add :second_resolution_code, :string
      add :second_resolution, :string

      timestamps()
    end
  end
end
