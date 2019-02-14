defmodule QuickcourtBackend.Repo.Migrations.CreateAgreementTypes do
  use Ecto.Migration

  def change do
    create table(:agreement_types) do
      add :code, :string
      add :name, :string

      timestamps()
    end

  end
end
