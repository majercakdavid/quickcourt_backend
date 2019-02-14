defmodule QuickcourtBackend.Shared.ResolutionType do
  use Ecto.Schema
  import Ecto.Changeset


  schema "resolution_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(resolution_type, attrs) do
    resolution_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
