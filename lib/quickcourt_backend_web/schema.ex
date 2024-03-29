defmodule QuickcourtBackendWeb.Schema do
  use Absinthe.Schema

  alias QuickcourtBackendWeb.Schema.Middleware

  alias QuickcourtBackendWeb.SharedResolver
  alias QuickcourtBackendWeb.CourtResolver
  alias QuickcourtBackendWeb.UserResolver

  import_types(QuickcourtBackendWeb.Schema.Types)
  import_types(Absinthe.Type.Custom)

  object :enumeration do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  input_object :enumeration_input do
    field :id, non_null(:id)
  end

  object :claim_rule do
    field :code, non_null(:string)
    field :label, non_null(:string)
  end

  object :claim do
    field :id, non_null(:id)

    field :case_number, non_null(:string)
    field :is_business, non_null(:boolean)
    field :claimant_name, non_null(:string)
    field :claimant_surname, non_null(:string)
    field :defendant_company_name, non_null(:string)
    field :claimant_city, non_null(:string)
    field :defendant_city, non_null(:string)
    field :claimant_zip, non_null(:string)
    field :defendant_zip, non_null(:string)
    field :claimant_country, non_null(:enumeration)
    field :defendant_country, non_null(:enumeration)
    field :claimant_address, non_null(:string)
    field :defendant_address, non_null(:string)
    field :claimant_email, non_null(:string)
    field :defendant_email, non_null(:string)
    field :claimant_phone, non_null(:string)
    field :defendant_phone, non_null(:string)
    field :agreement_type, non_null(:claim_rule)
    field :agreement_type_issue, non_null(:claim_rule)
    field :circumstances_invoked, non_null(:claim_rule)
    field :first_resolution, non_null(:claim_rule)
    field :second_resolution, :claim_rule
    field :purchase_country, :enumeration
    field :purchase_date, non_null(:datetime)
    field :delivery_country, :enumeration
    field :delivery_date, non_null(:datetime)

    field :lack_discovery_date, non_null(:datetime)
    field :contract_cancellation_date, :datetime
    field :goods_return_date, :datetime
    field(:issue_description, non_null(:string))
    field(:type_of_service_or_goods, non_null(:string))

    field(:damages_description, non_null(:string))
    field(:species_damages_description, :string)

    field :first_resolution_amount, :float
    field :second_resolution_amount, :float
    field :currency, non_null(:string)

    field :claim_status, non_null(:enumeration)

    field :pdf_base64_small_claim_form, :string
    field :pdf_base64_epo_a, :string
    field :pdf_base64_warning_letter, non_null(:string)

    field :inserted_at, :naive_datetime
  end

  query do
    @desc "Get list of all users"
    field :users, list_of(:user_type) do
      middleware(Middleware.Authorize, 1)
      resolve(&UserResolver.all_users/3)
    end

    @desc "Get the user profile"
    field :profile, :user_type do
      middleware(Middleware.Authorize, :any)
      resolve(&UserResolver.get_user/3)
    end

    @desc "Get claims that belongs to a user"
    field :claims, non_null(list_of(non_null(:claim))) do
      middleware(Middleware.Authorize, :any)
      resolve(&CourtResolver.get_user_claims/3)
    end

    field :claim, non_null(:claim) do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize, :any)
      resolve(&CourtResolver.get_claim/3)
    end

    field :countries, non_null(list_of(non_null(:enumeration))) do
      resolve(&SharedResolver.all_countries/3)
    end

    field :agreement_types, non_null(list_of(non_null(:claim_rule))) do
      resolve(&CourtResolver.all_agreement_types/3)
    end

    field :agreement_type_issues, non_null(list_of(non_null(:claim_rule))) do
      arg(:agreement_type_label, non_null(:string))
      resolve(&CourtResolver.all_agreement_type_issues/3)
    end

    field :claimant_description, :string do
      arg(:agreement_type_label, non_null(:string))
      arg(:agreement_type_issue_label, non_null(:string))
      resolve(&CourtResolver.get_claimant_description/3)
    end

    field :defendant_description, :string do
      arg(:agreement_type_label, non_null(:string))
      arg(:agreement_type_issue_label, non_null(:string))
      resolve(&CourtResolver.get_defendant_description/3)
    end

    field :circumstances_invoked, non_null(list_of(non_null(:claim_rule))) do
      arg(:agreement_type_label, non_null(:string))
      arg(:agreement_type_issue_label, non_null(:string))
      resolve(&CourtResolver.all_circumstances_invoked/3)
    end

    field :first_resolutions, non_null(list_of(non_null(:claim_rule))) do
      arg(:agreement_type_label, non_null(:string))
      arg(:agreement_type_issue_label, non_null(:string))
      arg(:circumstances_invoked_label, non_null(:string))
      resolve(&CourtResolver.all_first_resolutions/3)
    end

    field :second_resolutions, non_null(list_of(non_null(:claim_rule))) do
      arg(:agreement_type_label, non_null(:string))
      arg(:agreement_type_issue_label, non_null(:string))
      arg(:circumstances_invoked_label, non_null(:string))
      arg(:first_resolution_label, non_null(:string))
      resolve(&CourtResolver.all_second_resolutions/3)
    end
  end

  mutation do
    @desc "Register a new user"
    field :register_user, type: :session_type do
      arg(:input, non_null(:user_input_type))
      resolve(&UserResolver.register_user/3)
    end

    @desc "Login user and return a jwt token"
    field :login_user, type: :session_type do
      arg(:input, non_null(:session_input_type))
      resolve(&UserResolver.login_user/3)
    end

    @desc "Update claim status if it is longer than 14 days in warning sent status"
    field :update_claim_status, :claim do
      middleware(Middleware.Authorize, :any)
      arg(:id, non_null(:id))

      resolve(&CourtResolver.update_claim_status/3)
    end

    @desc "Create claim and generate all the necessary documents"
    field :create_claim, :claim do
      middleware(Middleware.Authorize, :any)

      arg(:is_business, non_null(:boolean))
      arg(:claimant_name, non_null(:string))
      arg(:claimant_surname, non_null(:string))
      arg(:defendant_company_name, non_null(:string))
      arg(:claimant_city, non_null(:string))
      arg(:defendant_city, non_null(:string))
      arg(:claimant_zip, non_null(:string))
      arg(:defendant_zip, non_null(:string))
      arg(:claimant_country_id, non_null(:integer))
      arg(:defendant_country_id, non_null(:integer))
      arg(:claimant_address, non_null(:string))
      arg(:defendant_address, non_null(:string))
      arg(:claimant_email, non_null(:string))
      arg(:defendant_email, non_null(:string))
      arg(:claimant_phone, non_null(:string))
      arg(:defendant_phone, non_null(:string))
      arg(:agreement_type_label, non_null(:string))
      arg(:agreement_type_issue_label, non_null(:string))
      arg(:circumstances_invoked_label, non_null(:string))
      arg(:first_resolution_label, non_null(:string))
      arg(:second_resolution_label, :string)

      arg(:purchase_country_id, :integer)
      arg(:purchase_date, non_null(:datetime))
      arg(:delivery_country_id, :integer)
      arg(:delivery_date, non_null(:datetime))

      arg(:lack_discovery_date, non_null(:datetime))
      arg(:contract_cancellation_date, :datetime)
      arg(:goods_return_date, :datetime)

      arg(:issue_description, non_null(:string))
      arg(:type_of_service_or_goods, non_null(:string))
      arg(:damages_description, non_null(:string))
      arg(:species_damages_description, :string)

      arg(:first_resolution_amount, :float)
      arg(:second_resolution_amount, :float)
      arg(:currency, non_null(:string))

      resolve(&CourtResolver.create_claim/3)
    end
  end
end
