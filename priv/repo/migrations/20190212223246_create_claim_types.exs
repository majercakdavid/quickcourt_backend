defmodule QuickcourtBackend.Repo.Migrations.CreateClaimTypes do
  use Ecto.Migration

  def change do
    create table(:claim_types) do
      add :name, :string

      timestamps()
    end

  end
end
