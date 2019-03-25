defmodule QuickcourtBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :user_type, :integer, default: 1

      timestamps()
    end

  end
end
