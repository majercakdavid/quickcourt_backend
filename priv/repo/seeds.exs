# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QuickcourtBackend.Repo.insert!(%QuickcourtBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias QuickcourtBackend.Shared.AgreementType
alias QuickcourtBackend.Shared.AgreementTypeIssue
alias QuickcourtBackend.Shared.IssueType
alias QuickcourtBackend.Shared.Country
alias QuickcourtBackend.Repo

agreement_types = [
  "01 Sales contract",
  "02 Rental agreement - movable property",
  "03 Rental agreement - immovable property",
  "04 Rental agreement - commercial lease",
  "05 Contract of service - electricity, gas, water, phone",
  "06 Contract of service - medical services",
  "07 Contract of service - transport",
  "08 Contract of service - legal, tax, technical advice",
  "09 Contract of service - hotel, restaurant",
  "10 Contract of service - repair",
  "11 Contract of service - brokerage",
  "12 Contract of service - other (please specify)",
  "13 Building contract",
  "14 Insurance contract",
  "15 Loan",
  "16 Guarantee or other collateral(s)",
  "17 Claims arising from non-contractual obligations…mission of debt (e.g. damages, unjust enrichment)",
  "18 Claims arising from joint ownership of property",
  "19 Damages - contract",
  "20 Subscription agreement (newspaper, magazine)",
  "21 Membership fee",
  "22 Employment agreement",
  "23 Out-of-court settlement",
  "24 Maintenance agreement",
  "25 Other (please specify)"
]

agreement_type_issues = [
  "Cancellation",
  "Faulty goods or services",
  "Issue with payment",
  "Issue with delivery",
  "Issue with unfair contract terms"
]

resolution_types = [
  "7_1_cancellation_eu_us",
  "7_2_7_1_demand_repair_replacement_according_to_contract",
  "7_2_demand_repair_replacement_faulty_service_damage_option_1_eu",
  "7_1_issue_with_delivery_eu_us",
  "7_2_7_1_issue_with_unfair_contract_terms_term_cancellation",
  "7_2_7_1_issue_with_unfair_contract_terms_contract_cancellation"
]

issue_types = [
  "30 Non-payment",
  "31 Insufficient payment",
  "32 Late payment",
  "33 Non-delivery of goods or services",
  "34 Delivery of defective goods or poor services",
  "35 Goods or services not in conformity with the order",
  "36 Other (please specify)"
]

eu_countries = [
  "Austria",
  "Italy",
  "Belgium",
  "Latvia",
  "Bulgaria",
  "Lithuania",
  "Croatia",
  "Luxembourg",
  "Cyprus",
  "Malta",
  "Czechia",
  "Netherlands",
  "Denmark",
  "Poland",
  "Estonia",
  "Portugal",
  "Finland",
  "Romania",
  "France",
  "Slovakia",
  "Germany",
  "Slovenia",
  "Greece",
  "Spain",
  "Hungary",
  "Sweden",
  "Ireland",
  "United Kingdom"
]

Enum.each(agreement_types, fn agreement_type ->
  code = String.slice(agreement_type, 0..1)
  name = String.slice(agreement_type, 3..-1)
  %AgreementType{code: code, name: name} |> Repo.insert!()
end)

Enum.each(agreement_type_issues, fn agreement_type_issue ->
  %AgreementTypeIssue{name: agreement_type_issue} |> Repo.insert!()
end)

Enum.each(issue_types, fn issue_type ->
  code = String.slice(issue_type, 0..1)
  name = String.slice(issue_type, 3..-1)
  %IssueType{code: code, name: name} |> Repo.insert!()
end)

Enum.each(eu_countries, fn eu_country ->
  %Country{name: eu_country} |> Repo.insert!()
end)
