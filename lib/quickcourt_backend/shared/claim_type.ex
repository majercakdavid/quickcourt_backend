defmodule QuickcourtBackend.Shared.ClaimType do
  use Ecto.Schema
  import Ecto.Changeset


  schema "claim_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(claim_type, attrs) do
    claim_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
