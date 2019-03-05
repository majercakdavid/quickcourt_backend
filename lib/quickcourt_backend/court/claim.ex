defmodule QuickcourtBackend.Court.Claim do
  use Ecto.Schema
  import Ecto.Changeset

  alias QuickcourtBackend.Shared.Country
  alias QuickcourtBackend.Shared.AgreementType
  alias QuickcourtBackend.Shared.IssueType
  # alias QuickcourtBackend.Shared.ResolutionType

  schema "claims" do
    field :case_number, :string
    field :is_business, :boolean, default: false
    field :claimant_name, :string
    field :claimant_surname, :string
    field :defendant_company_name, :string
    field :claimant_city, :string
    field :defendant_city, :string
    field :claimant_zip, :string
    field :defendant_zip, :string
    belongs_to :claimant_country, Country
    belongs_to :defendant_country, Country
    field :claimant_address, :string
    field :defendant_address, :string
    field :claimant_email, :string
    field :defendant_email, :string
    field :claimant_phone, :string
    field :defendant_phone, :string
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
    |> cast(attrs, [
      :is_business,
      :claimant_email,
      :defendant_email,
      :claimant_phone,
      :defendant_phone,
      :claimant_name,
      :claimant_surname,
      :defendant_company_name,
      :claimant_city,
      :defendant_city,
      :claimant_zip,
      :defendant_zip,
      :claimant_address,
      :defendant_address,
      :purchase_place,
      :purchase_date,
      :delivery_place,
      :delivery_date,
      :lack_discovery_date,
      :claimant_country_id,
      :defendant_country_id,
      :agreement_type_id,
      :issue_type_id
    ])
    |> validate_required([:claimant_country_id, :defendant_country_id])
    |> fields_not_equal(:claimant_country_id, :defendant_country_id)
    |> foreign_key_constraint(:claimant_country_id)
    |> foreign_key_constraint(:defendant_country_id)
    |> foreign_key_constraint(:agreement_type_id)
    |> foreign_key_constraint(:issue_type_id)
    |> validate_required([:is_business])
  end

  defp fields_not_equal(changeset, field1, field2) do
    val1 = get_field(changeset, field1)
    val2 = get_field(changeset, field2)

    fields_not_equal(changeset, field1, field2, val1, val2)
  end

  defp fields_not_equal(changeset, field1, field2, val1, val2) when val1 == val2 do
    add_error(
      changeset,
      field1,
      Atom.to_string(field1) <> " cannot be equal to " <> Atom.to_string(field2)
    )
  end

  defp fields_not_equal(changeset, _, _, _, _), do: changeset
end
