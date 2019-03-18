defmodule QuickcourtBackendWeb.CourtResolver do
  alias QuickcourtBackend.Court
  alias QuickcourtBackend.ClaimPdfGenerator

  def all_claims(_root, _args, _info) do
    claims = Court.list_claims()
    {:ok, claims}
  end

  def create_claim(_root, args, _info) do
    case Court.create_claim(args) do
      {:ok, claim} ->
        try do
          generated_pdf_small_claim_form = ClaimPdfGenerator.generate_small_claim_form_pdf(claim)
          generated_pdf_epo_a = ClaimPdfGenerator.generate_epo_a_pdf(claim)
          generated_pdf_warning_letter = ClaimPdfGenerator.generate_warning_letter_pdf(claim)

          result =
            Map.from_struct(claim)
            |> Map.merge(%{pdf_base64_small_claim_form: generated_pdf_small_claim_form})
            |> Map.merge(%{pdf_base64_epo_a: generated_pdf_epo_a})
            |> Map.merge(%{pdf_base64_warning_letter: generated_pdf_warning_letter})

          {:ok, result}
        rescue
          RuntimeError -> {:error, "There was an error generating PDF document(s)"}
        end

      {:error, errors} ->
        {:error, "Errors:" <> inspect(errors)}
    end
  end

  def all_agreement_types(_root, _args, _info) do
    agreement_types = Court.list_agreement_types()
    {:ok, agreement_types}
  end

  def all_agreement_type_issues(_root, %{agreement_type: agreement_type}, _info) do
    agreement_type_issues = Court.list_agreement_type_issues(agreement_type)
    {:ok, agreement_type_issues}
  end

  def all_circumstances_invoked(
        _root,
        %{agreement_type: agreement_type, agreement_type_issue: agreement_type_issue},
        _info
      ) do
    agreement_type_issues = Court.list_circumstances_invoked(agreement_type, agreement_type_issue)
    {:ok, agreement_type_issues}
  end

  def all_first_resolutions(
        _root,
        %{
          agreement_type: agreement_type,
          agreement_type_issue: agreement_type_issue,
          circumstance_invoked: circumstance_invoked
        },
        _info
      ) do
    first_resolutions =
      Court.list_first_resolutions(agreement_type, agreement_type_issue, circumstance_invoked)

    {:ok, first_resolutions}
  end

  def all_second_resolutions(
        _root,
        %{
          agreement_type: agreement_type,
          agreement_type_issue: agreement_type_issue,
          circumstance_invoked: circumstance_invoked
        },
        _info
      ) do
    second_resolutions =
      Court.list_second_resolutions(agreement_type, agreement_type_issue, circumstance_invoked)

    {:ok, second_resolutions}
  end
end
