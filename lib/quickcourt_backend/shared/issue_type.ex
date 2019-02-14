defmodule QuickcourtBackend.Shared.IssueType do
  use Ecto.Schema
  import Ecto.Changeset


  schema "issue_types" do
    field :code, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(issue_type, attrs) do
    issue_type
    |> cast(attrs, [:code])
    |> cast(attrs, [:name])
    |> validate_required([:code])
    |> validate_required([:name])
  end
end
