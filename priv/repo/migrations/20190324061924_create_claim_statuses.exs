defmodule QuickcourtBackend.Repo.Migrations.CreateClaimStatuses do
  use Ecto.Migration

  def change do
    create table(:claim_statuses) do
      add :label, :string

      timestamps()
    end
  end
end
