defmodule QuickcourtBackend.Court.Claim do
  use Ecto.Schema
  import Ecto.Changeset

  alias QuickcourtBackend.Shared.Country
  alias QuickcourtBackend.Court.ClaimStatus
  alias QuickcourtBackend.Auth.User

  schema "claims" do
    # Claimant part
    field :is_business, :boolean, default: false
    field :claimant_name, :string
    field :claimant_surname, :string
    field :claimant_city, :string
    field :claimant_zip, :string
    belongs_to :claimant_country, Country
    field :claimant_address, :string
    field :claimant_email, :string
    field :claimant_phone, :string

    # Defendant part
    field :defendant_company_name, :string
    field :defendant_city, :string
    field :defendant_zip, :string
    belongs_to :defendant_country, Country
    field :defendant_address, :string
    field :defendant_email, :string
    field :defendant_phone, :string

    # Claim part
    field :case_number, :string
    field :agreement_type_label, :string
    field :agreement_type_issue_label, :string
    field :circumstances_invoked_label, :string
    field :first_resolution_label, :string
    field :second_resolution_label, :string
    belongs_to :purchase_country, Country
    field :purchase_date, :utc_datetime
    belongs_to :delivery_country, Country
    field :delivery_date, :utc_datetime

    field :lack_discovery_date, :utc_datetime
    field :contract_cancellation_date, :utc_datetime
    field :goods_return_date, :utc_datetime
    field :issue_description, :string
    field :type_of_service_or_goods, :string

    field :damages_description, :string
    field :species_damages_description, :string

    field :claim_for_money, :boolean, default: false
    field :amount, :float, default: nil
    field :currency, :string, default: nil

    # Claim stages
    belongs_to :claim_status, ClaimStatus

    # After warning status expiration
    # field :final_resolution_id, 

    # To not to send arbitraty emails when checking which
    # claims are expired
    field :warning_expiration_email_sent_on, :utc_datetime

    # Claimant user
    belongs_to :user, User
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
      :purchase_country_id,
      :purchase_date,
      :delivery_country_id,
      :delivery_date,
      :lack_discovery_date,
      :contract_cancellation_date,
      :goods_return_date,
      :claimant_country_id,
      :defendant_country_id,
      :agreement_type_label,
      :agreement_type_issue_label,
      :circumstances_invoked_label,
      :first_resolution_label,
      :second_resolution_label,
      :issue_description,
      :type_of_service_or_goods,
      :damages_description,
      :species_damages_description,
      :claim_for_money,
      :amount,
      :currency,
      :claim_status_id,
      :warning_expiration_email_sent_on,
      :user_id
    ])
    |> validate_required([
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
      :purchase_country_id,
      :purchase_date,
      :delivery_country_id,
      :delivery_date,
      :lack_discovery_date,
      :contract_cancellation_date,
      :claimant_country_id,
      :defendant_country_id,
      :agreement_type_label,
      :agreement_type_issue_label,
      :circumstances_invoked_label,
      :first_resolution_label,
      :issue_description,
      :type_of_service_or_goods,
      :damages_description,
      :claim_for_money,
      :amount,
      :currency,
      :claim_status_id,
      :user_id
    ])
    |> fields_not_equal(:claimant_country_id, :defendant_country_id)
    |> validate_format(:claimant_email, ~r/@/)
    |> update_change(:claimant_email, &String.downcase(&1))
    |> validate_format(:defendant_email, ~r/@/)
    |> update_change(:defendant_email, &String.downcase(&1))
    |> validate_and_translate_claim_rule()
    |> foreign_key_constraint(:claimant_country_id)
    |> foreign_key_constraint(:defendant_country_id)
    |> foreign_key_constraint(:purchase_country_id)
    |> foreign_key_constraint(:delivery_country_id)
    |> foreign_key_constraint(:claim_status_id)
    |> foreign_key_constraint(:user_id)
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

  defp validate_and_translate_claim_rule(changeset) do
    agreement_type_label = get_field(changeset, :agreement_type_label)
    agreement_type_issue_label = get_field(changeset, :agreement_type_issue_label)
    circumstances_invoked_label = get_field(changeset, :circumstances_invoked_label)
    first_resolution_label = get_field(changeset, :first_resolution_label)
    second_resolution_label = get_field(changeset, :second_resolution_label, nil)

    case QuickcourtBackend.Court.get_claim_rules_by_labels(
           agreement_type_label,
           agreement_type_issue_label,
           circumstances_invoked_label,
           first_resolution_label,
           second_resolution_label
         ) do
      [_ | []] ->
        changeset

      [] ->
        add_error(
          changeset,
          :agreement_type_label,
          "Combination of agreement_type_label, agreement_type_issue_label, circumstances_invoked_label, first_resolution_label, second_resolution_label is invalid"
        )

      [_ | _] ->
        add_error(
          changeset,
          :second_resolution_label,
          "Combination of agreement_type_label, agreement_type_issue_label, circumstances_invoked_label, first_resolution_label, second_resolution_label is ambigious, probably you are missing second_resolution_label"
        )
    end
  end
end
