defmodule QuickcourtBackend.Court.ClaimStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "claim_statuses" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(claim_status, attrs) do
    claim_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
