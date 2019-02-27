defmodule QuickcourtBackendWeb.SharedResolver do
  alias QuickcourtBackend.Shared

  def all_countries(_root, _args, _info) do
    countries = Shared.list_countries()
    {:ok, countries}
  end

  def all_claim_types(_root, _args, _info) do
    claim_types = Shared.list_claim_types()
    {:ok, claim_types}
  end

  def all_issue_types(_root, _args, _info) do
    issue_types = Shared.list_issue_types()
    {:ok, issue_types}
  end

  def all_agreement_types(_root, _args, _info) do
    agreement_types = Shared.list_agreement_types()
    {:ok, agreement_types}
  end

  def all_agreement_type_issues(_root, _args, _info) do
    agreement_types = Shared.list_agreement_type_issues()
    {:ok, agreement_types}
  end

  def all_resolution_types(_root, _args, _info) do
    resolution_types = Shared.list_resolution_types()
    {:ok, resolution_types}
  end

  # def create_country(_root, args, _info) do
  #     case Shared.create_country(args) do
  #         {:ok, country} ->
  #             {:ok, country}
  #         _error ->
  #             {:error, "could not create country"}
  #     end
  # end
end