defmodule QuickcourtBackend.Court.Claim do
  use Ecto.Schema
  import Ecto.Changeset

  alias QuickcourtBackend.Shared.Country
  alias QuickcourtBackend.Shared.AgreementType
  alias QuickcourtBackend.Shared.IssueType
  alias QuickcourtBackend.Shared.ResolutionType

  schema "claims" do
    field :is_business, :boolean, default: false
    belongs_to :claimant_country, Country
    belongs_to :defendant_country, Country
    field :claimant_address, :string
    field :defendant_address, :string
    belongs_to :agreement_type, AgreementType
    belongs_to :issue_type, IssueType
    # belongs_to :resolution_type, ResolutionType
    field :purchase_place, :string, default: "online"
    field :purchase_date, :utc_datetime
    field :delivery_place, :string, default: "online"
    field :delivery_date, :utc_datetime
    field :lack_discovery_date, :utc_datetime
    timestamps()
  end

  @doc false
  def changeset(claim, attrs) do
    claim
    |> cast(attrs, [:is_business, :claimant_address, :defendant_address, :purchase_place, :purchase_date, :delivery_place, :delivery_date, :lack_discovery_date, :claimant_country_id, :defendant_country_id, :agreement_type_id, :issue_type_id])
    |> foreign_key_constraint(:claimant_country_id)
    |> foreign_key_constraint(:defendant_country_id)
    |> foreign_key_constraint(:agreement_type_id)
    |> foreign_key_constraint(:issue_type_id)
    |> validate_required([:is_business])
  end
end
