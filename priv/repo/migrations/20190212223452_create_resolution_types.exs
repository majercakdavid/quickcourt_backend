defmodule QuickcourtBackend.Repo.Migrations.CreateResolutionTypes do
  use Ecto.Migration

  def change do
    create table(:resolution_types) do
      add :name, :string

      timestamps()
    end

  end
end
