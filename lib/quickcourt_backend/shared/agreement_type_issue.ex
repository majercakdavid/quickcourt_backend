defmodule QuickcourtBackend.Shared.AgreementTypeIssue do
  use Ecto.Schema
  import Ecto.Changeset


  schema "agreement_type_issues" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(agreement_type_issue, attrs) do
    agreement_type_issue
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
