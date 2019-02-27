defmodule QuickcourtBackend.Repo.Migrations.CreateAgreementTypeIssues do
  use Ecto.Migration

  def change do
    create table(:agreement_type_issues) do
      add :name, :string

      timestamps()
    end

  end
end
