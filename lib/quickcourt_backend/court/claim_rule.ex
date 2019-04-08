defmodule QuickcourtBackend.Court.ClaimRule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "claim_rules" do
    field :agreement_type, :string
    field :agreement_type_issue, :string
    field :circumstances_invoked, :string
    field :circumstances_invoked_code, :string
    field :first_resolution, :string
    field :first_resolution_code, :string
    field :second_resolution, :string
    field :second_resolution_code, :string

    timestamps()
  end

  @doc false
  def changeset(claim_rule, attrs) do
    claim_rule
    |> cast(attrs, [
      :agreement_type,
      :agreement_type_issue,
      :circumstances_invoked_code,
      :circumstances_invoked,
      :first_resolution_code,
      :first_resolution,
      :second_resolution_code,
      :second_resolution
    ])

    # |> validate_required([
    #   :agreement_type,
    #   :agreement_type_issue,
    #   :circumstances_invoked_code,
    #   :circumstances_invoked,
    #   :first_resolution_code,
    #   :first_resolution,
    #   :second_resolution_code,
    #   :second_resolution
    # ])
  end
end
