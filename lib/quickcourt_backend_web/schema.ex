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

  object :agreement_type do
    field :code, non_null(:string)
    field :label, non_null(:string)
  end

  object :agreement_type_issue do
    field :label, non_null(:string)
  end

  object :circumstances_invoked do
    field :code, non_null(:string)
    field :label, non_null(:string)
  end

  object :resolution do
    field :code, non_null(:string)
    field :label, non_null(:string)
  end

  input_object :agreement_type_input do
    field :id, non_null(:id)
  end

  input_object :issue_type_input do
    field :id, non_null(:id)
  end

  object :claim do
    field :is_business, non_null(:boolean)
    field :claimant_name, non_null(:string)
    field :claimant_surname, non_null(:string)
    field :defendant_company_name, non_null(:string)
    field :claimant_city, non_null(:string)
    field :defendant_city, non_null(:string)
    field :claimant_zip, non_null(:string)
    field :defendant_zip, non_null(:string)
    field :claimant_country, non_null(:string)
    field :defendant_country, non_null(:string)
    field :claimant_address, non_null(:string)
    field :defendant_address, non_null(:string)
    field :claimant_email, non_null(:string)
    field :defendant_email, non_null(:string)
    field :claimant_phone, non_null(:string)
    field :defendant_phone, non_null(:string)
    field :agreement_type, non_null(:string)
    field :agreement_type_issue, non_null(:string)
    field :circumstance_invoked, non_null(:string)
    field :first_resolution, non_null(:string)
    field :second_resolution, non_null(:string)
    field :purchase_country, :string
    field :purchase_date, non_null(:datetime)
    field :delivery_country, :string
    field :delivery_date, non_null(:datetime)
    field :lack_discovery_date, non_null(:datetime)

    field :genus_description, non_null(:string)
    field :spieces_description, non_null(:string)

    field :claim_for_money, non_null(:boolean)
    field :amount, non_null(:float)
    field :currency, non_null(:string)

    field :pdf_base64_small_claim_form, non_null(:string)
    field :pdf_base64_epo_a, non_null(:string)
    field :pdf_base64_warning_letter, non_null(:string)
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

    field :countries, non_null(list_of(non_null(:enumeration))) do
      resolve(&SharedResolver.all_countries/3)
    end

    field :agreement_types, non_null(list_of(non_null(:agreement_type))) do
      resolve(&CourtResolver.all_agreement_types/3)
    end

    field :agreement_type_issues, non_null(list_of(non_null(:agreement_type_issue))) do
      arg(:agreement_type, non_null(:string))
      resolve(&CourtResolver.all_agreement_type_issues/3)
    end

    field :circumstances_invoked, non_null(list_of(non_null(:circumstances_invoked))) do
      arg(:agreement_type, non_null(:string))
      arg(:agreement_type_issue, non_null(:string))
      resolve(&CourtResolver.all_circumstances_invoked/3)
    end

    field :first_resolutions, non_null(list_of(non_null(:resolution))) do
      arg(:agreement_type, non_null(:string))
      arg(:agreement_type_issue, non_null(:string))
      arg(:circumstance_invoked, non_null(:string))
      resolve(&CourtResolver.all_first_resolutions/3)
    end

    field :second_resolutions, non_null(list_of(non_null(:resolution))) do
      arg(:agreement_type, non_null(:string))
      arg(:agreement_type_issue, non_null(:string))
      arg(:circumstance_invoked, non_null(:string))
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
      arg(:agreement_type, non_null(:string))
      arg(:agreement_type_issue, non_null(:string))
      arg(:circumstance_invoked, non_null(:string))

      arg(:first_resolution, non_null(:string))
      arg(:second_resolution, :string)

      arg(:purchase_country_id, :integer)
      arg(:purchase_date, non_null(:datetime))
      arg(:delivery_country_id, :integer)
      arg(:delivery_date, non_null(:datetime))
      arg(:lack_discovery_date, non_null(:datetime))

      arg(:genus_description, non_null(:string))
      arg(:spieces_description, non_null(:string))

      arg(:claim_for_money, non_null(:boolean))
      arg(:amount, non_null(:float))
      arg(:currency, non_null(:string))

      resolve(&CourtResolver.create_claim/3)
    end
  end
end
