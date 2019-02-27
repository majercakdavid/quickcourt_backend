defmodule QuickcourtBackendWeb.Schema do
  use Absinthe.Schema

  alias QuickcourtBackendWeb.SharedResolver
  alias QuickcourtBackendWeb.CourtResolver

  import_types(Absinthe.Type.Custom)

  object :enumeration do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  input_object :enumeration_input do
    field :id, non_null(:id)
  end

  object :agreement_type do
    field :id, non_null(:id)
    field :code, non_null(:string)
    field :name, non_null(:string)
  end

  object :agreement_type_issue do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  input_object :agreement_type_input do
    field :id, non_null(:id)
  end

  object :issue_type do
    field :id, non_null(:id)
    field :code, non_null(:string)
    field :name, non_null(:string)
  end

  input_object :issue_type_input do
    field :id, non_null(:id)
  end

  object :claim do
    field :is_business, non_null(:boolean)
    field(:claimant_country, non_null(:enumeration))
    field(:defendant_country, non_null(:enumeration))
    field :claimant_address, non_null(:string)
    field :defendant_address, non_null(:string)
    field(:agreement_type, non_null(:agreement_type))
    field(:issue_type, non_null(:issue_type))
    field :purchase_place, :string
    field :purchase_date, non_null(:datetime)
    field :delivery_place, :string
    field :delivery_date, non_null(:datetime)
    field :lack_discovery_date, non_null(:datetime)
    field :pdf_base64, :string
  end

  query do
    field :countries, list_of(:enumeration) do
      resolve(&SharedResolver.all_countries/3)
    end

    # field :claim_types, list_of(:enumeration) do
    #     resolve &SharedResolver.all_claim_types/3
    # end

    field :issue_types, list_of(:issue_type) do
      resolve(&SharedResolver.all_issue_types/3)
    end

    field :agreement_types, list_of(:agreement_type) do
      resolve(&SharedResolver.all_agreement_types/3)
    end

    field :agreement_type_issues, list_of(:agreement_type_issue) do
      resolve(&SharedResolver.all_agreement_type_issues/3)
    end

    # field :resolution_types, list_of(:enumeration) do
    #     resolve &SharedResolver.all_resolution_types/3
    # end

    # field :claims, list_of(:claim) do
    #   resolve(&CourtResolver.all_claims/3)
    # end
  end

  mutation do
    # field :create_country, :enumeration do
    #     arg :name, non_null(:string)
    #     resolve &SharedResolver.create_country/3
    # end
    field :create_claim, :claim do
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
      arg(:agreement_type_id, non_null(:integer))
      arg(:issue_type_id, non_null(:integer))
      arg(:purchase_place, :string)
      arg(:purchase_date, non_null(:datetime))
      arg(:delivery_place, :string)
      arg(:delivery_date, non_null(:datetime))
      arg(:lack_discovery_date, non_null(:datetime))

      resolve(&CourtResolver.create_claim/3)
    end
  end
end
