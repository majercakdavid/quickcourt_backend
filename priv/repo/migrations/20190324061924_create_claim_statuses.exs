defmodule QuickcourtBackend.Repo.Migrations.CreateClaimStatuses do
  use Ecto.Migration

  def change do
    create table(:claim_statuses) do
      add :name, :string

      timestamps()
    end
  end
end
