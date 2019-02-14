defmodule QuickcourtBackend.Repo.Migrations.CreateIssueTypes do
  use Ecto.Migration

  def change do
    create table(:issue_types) do
      add :code, :string
      add :name, :string

      timestamps()
    end

  end
end
