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

alias QuickcourtBackend.Court.ClaimRule
alias QuickcourtBackend.Repo

File.stream!("./priv/repo/consumer_choices.csv")
|> Stream.drop(1)
|> CSV.decode(
  headers: [
    :agreement_type,
    :agreement_type_issue,
    :cicumstance_invoked_code,
    :circumstance_invoked,
    :first_resolution_code,
    :first_resolution,
    :second_resolution_code,
    :second_resolution
  ]
)
|> Enum.each(fn {:ok, record} ->
  IO.inspect(record)
  changeset = ClaimRule.changeset(%ClaimRule{}, record)
  Repo.insert!(changeset)
end)

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

Enum.each(eu_countries, fn eu_country ->
  %Country{name: eu_country} |> Repo.insert!()
end)
