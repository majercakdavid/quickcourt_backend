defmodule QuickcourtBackend.Shared.AgreementType do
  use Ecto.Schema
  import Ecto.Changeset


  schema "agreement_types" do
    field :code, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(agreement_type, attrs) do
    agreement_type
    |> cast(attrs, [:code])
    |> cast(attrs, [:name])
    |> validate_required([:code])
    |> validate_required([:name])
  end
end
