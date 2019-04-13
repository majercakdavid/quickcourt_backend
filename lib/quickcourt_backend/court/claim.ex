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

    field :first_resolution_amount, :float, default: nil
    field :second_resolution_amount, :float, default: nil
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
      :first_resolution_amount,
      :second_resolution_amount,
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
      :currency,
      :claim_status_id,
      :user_id
    ])
    # Basic string validations

    ## CLAIMANT
    |> validate_length(:claimant_name, min: 3)
    |> validate_length(:claimant_surname, min: 3)
    |> validate_length(:claimant_city, min: 3)
    |> validate_length(:claimant_zip, min: 3)
    |> validate_length(:claimant_address, min: 4)
    |> validate_length(:claimant_email, min: 3)
    |> validate_format(:claimant_email, ~r/@/)
    |> update_change(:claimant_email, &String.downcase(&1))
    |> validate_length(:claimant_phone, min: 8, max: 13)

    ## DEFENDANT
    |> validate_length(:defendant_company_name, min: 3)
    |> validate_length(:defendant_city, min: 3)
    |> validate_length(:defendant_zip, min: 3)
    |> validate_length(:defendant_address, min: 4)
    |> validate_length(:defendant_email, min: 3)
    |> validate_format(:defendant_email, ~r/@/)
    |> update_change(:defendant_email, &String.downcase(&1))
    |> validate_length(:defendant_phone, min: 8, max: 13)

    ## CLAIM FIELDS
    |> validate_length(:issue_description, min: 5)
    |> validate_length(:type_of_service_or_goods, min: 3)

    ## BUSINESS LOGIC

    # conditional validations according to the user input (sales contract)
    |> validate_conditional_required()
    |> validate_conditional_rules()

    # validates agreement_type_type, agreement_type_issue, circumstances_invoked
    # first_resolution and second_resolution (whether it is presented in db as rule)
    |> validate_claim_rule()

    # as we are focusing on european claims we do not want to
    # bother with claims within one country
    |> fields_not_equal(:claimant_country_id, :defendant_country_id)

    # DATES
    |> validate_date_against_today(:purchase_date, :lt)
    |> validate_date_against_today(:delivery_date, :lt)
    |> validate_date_against_today(:lack_discovery_date, :lt)
    |> validate_date_against_today(:contract_cancellation_date, :lt)
    |> validate_date_against_today(:goods_return_date, :lt)

    # CURRENCY
    |> validate_currency_code(:currency)

    ## FOREIGN KEYS
    |> foreign_key_constraint(:claimant_country_id)
    |> foreign_key_constraint(:defendant_country_id)
    |> foreign_key_constraint(:purchase_country_id)
    |> foreign_key_constraint(:delivery_country_id)
    |> foreign_key_constraint(:claim_status_id)
    |> foreign_key_constraint(:user_id)
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
      "cannot be equal to " <> Atom.to_string(field2)
    )
  end

  defp fields_not_equal(changeset, _, _, _, _), do: changeset

  def validate_date_against_today(changeset, field, opts \\ []) do
    if date_val = get_field(changeset, field) do
      do_validate_date_against_today(changeset, field, date_val, opts)
    else
      changeset
    end
  end

  defp do_validate_date_against_today(changeset, field, date, opts) do
    today = Date.utc_today()

    changeset =
      if opts == :lt and Date.compare(date, today) != :lt do
        changeset
        |> add_error(field, "cannot be future date")
      else
        changeset
      end

    changeset =
      if opts == :gt and Date.compare(date, today) != :gt do
        changeset
        |> add_error(field, "cannot be past date")
      else
        changeset
      end

    changeset
  end

  defp validate_dates_days_difference(changeset, begin_date_field, end_date_field, max_days_count) do
    IO.inspect(begin_date_field)
    IO.inspect(end_date_field)

    if begin_date_val = get_field(changeset, begin_date_field) do
      if end_date_val = get_field(changeset, end_date_field) do
        diff = Date.diff(end_date_val, begin_date_val)

        IO.inspect(diff)

        do_validate_dates_days_difference(
          changeset,
          begin_date_field,
          end_date_field,
          diff,
          max_days_count
        )
      else
        changeset
      end
    else
      changeset
    end
  end

  defp do_validate_dates_days_difference(changeset, begin_date_field, end_date_field, diff, _)
       when diff < 0 do
    changeset
    |> add_error(begin_date_field, "Must be smaller than " <> Atom.to_string(end_date_field))
  end

  defp do_validate_dates_days_difference(
         changeset,
         begin_date_field,
         end_date_field,
         diff,
         max_days_count
       )
       when diff > max_days_count do
    changeset
    |> add_error(
      begin_date_field,
      "can differ at maximum by " <>
        inspect(max_days_count) <> " days from " <> Atom.to_string(end_date_field)
    )
  end

  defp do_validate_dates_days_difference(changeset, _, _, _, _), do: changeset

  defp validate_currency_code(changeset, field) do
    eu_currency_codes = [
      "BGN",
      "CYP",
      "DKK",
      "EEK",
      "EUR",
      "GBP",
      "HUF",
      "LTL",
      "LVL",
      "MTL",
      "PLN",
      "RON",
      "SEK"
    ]

    if field_val = get_field(changeset, field) do
      case Enum.member?(eu_currency_codes, field_val) do
        true ->
          changeset

        _ ->
          changeset
          |> add_error(
            field,
            "allows only for the following currency codes: " <>
              Enum.join(eu_currency_codes, ", ")
          )
      end
    else
      changeset
    end
  end

  defp validate_conditional_rules(changeset) do
    # for claims for goods and agreement_type_issue == Cancellation
    agreement_type = get_field(changeset, :agreement_type_label)
    agreement_type_issue = get_field(changeset, :agreement_type_issue_label)

    changeset =
      case agreement_type == "01 Sales contract" and agreement_type_issue == "Cancellation" do
        true ->
          changeset
          # according to the law a buyer can cancel an order at most 14 days after he bought an item
          # this item must be sent at most 14 days after the order was cancelled
          |> validate_dates_days_difference(:delivery_date, :contract_cancellation_date, 14)
          |> validate_dates_days_difference(:contract_cancellation_date, :goods_return_date, 14)

        _ ->
          changeset
      end

    # TODO: ASK HOW IS IT WITH THE SERVICES AND OTHER TYPES OF AGREEMENT TYPES BESIDES SALES
    changeset =
      case String.downcase(agreement_type) =~ "service" and agreement_type_issue == "Cancellation" do
        true ->
          changeset
          # according to the law a buyer can cancel an order at 2 months after it was executed
          |> validate_dates_days_difference(:delivery_date, :contract_cancellation_date, 60)

        _ ->
          changeset
      end
  end

  defp validate_conditional_required(changeset) do
    # for claims for goods and agreement_type_issue == Cancellation
    agreement_type = get_field(changeset, :agreement_type_label)
    agreement_type_issue = get_field(changeset, :agreement_type_issue_label)

    if agreement_type == "01 Sales contract" and agreement_type_issue == "Cancellation" do
      changeset
      |> validate_required(:goods_return_date)
    else
      changeset
    end
  end

  defp validate_claim_rule(changeset) do
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
