defmodule QuickcourtBackendWeb.Schema do
  use Absinthe.Schema

  alias QuickcourtBackendWeb.SharedResolver

  object :enumeration do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :agreement_type do
    field :id, non_null(:id)
    field :code, non_null(:string)
    field :name, non_null(:string)
  end

  object :issue_type do
    field :id, non_null(:id)
    field :code, non_null(:string)
    field :name, non_null(:string)
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

    # field :resolution_types, list_of(:enumeration) do
    #     resolve &SharedResolver.all_resolution_types/3
    # end
  end

  # mutation do
  #     field :create_country, :country do
  #         arg :name, non_null(:string)\

  #         resolve &SharedResolver.create_country/3
  #     end
  # end
end
