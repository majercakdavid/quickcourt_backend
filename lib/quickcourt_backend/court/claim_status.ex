defmodule QuickcourtBackend.Court.ClaimStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "claim_statuses" do
    field :label, :string

    timestamps()
  end

  @doc false
  def changeset(claim_status, attrs) do
    claim_status
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
