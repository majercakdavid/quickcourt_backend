defmodule QuickcourtBackendWeb.CourtResolver do
  alias QuickcourtBackend.Court
  alias QuickcourtBackend.ClaimPdfGenerator

  @type user_context() :: %{current_user: Auth.User}

  def all_claims(_root, _args, _info) do
    claims = Court.list_claims()
    {:ok, claims}
  end

  @spec update_claim_status(any(), any(), user_context()) :: any()
  def update_claim_status(_root, %{claim_id: claim_id}, _info = %{context: %{current_user: user}}) do
    with claim <- Court.get_claim!(claim_id),
         true <- claim_belongs_to_user?(claim, user),
         true <- warning_expired?(claim),
         true <- can_be_updated?(claim),
         {:ok, new_claim} <- Court.update_claim(claim, %{claim_status_id: 5}) do
      {:ok, new_claim}
    else
      {:error, info} -> {:error, info}
    end
  end

  @spec create_claim(any(), any(), user_context()) :: any()
  def create_claim(_root, args, %{context: %{current_user: user}}) do
    case args
         |> Map.merge(%{user_id: user.id, claim_status_id: 1})
         |> Court.create_claim() do
      {:ok, %{claim: claim, warning_letter_pdf: warning_letter_pdf}} ->
        try do
          result =
            Map.from_struct(claim)
            |> Map.merge(%{pdf_base64_warning_letter: Base.encode64(warning_letter_pdf)})
            |> Map.merge(%{pdf_base64_small_claim_form: nil})
            |> Map.merge(%{pdf_base64_epo_a: nil})

          {:ok, result}
        rescue
          RuntimeError -> {:error, "There was an error generating PDF document(s)"}
        end

      {:error, errors} ->
        {:error, "Errors:" <> inspect(errors)}
    end
  end

  def get_user_claims(_root, _args, info = %{context: %{current_user: user}}) do
    queried_fields = Absinthe.Resolution.project(info) |> Enum.map(& &1.name)

    claims =
      Court.list_user_claims(user.id)
      |> Enum.map(fn claim ->
        claim =
          case Enum.member?(queried_fields, "pdfBase64WarningLetter") do
            true ->
              warning_letter_pdf = ClaimPdfGenerator.generate_warning_letter_pdf(claim)
              Map.merge(claim, %{pdf_base64_warning_letter: Base.encode64(warning_letter_pdf)})

            _ ->
              claim
          end

        claim
        |> Map.merge(%{pdf_base64_small_claim_form: nil})
        |> Map.merge(%{pdf_base64_epo_a: nil})
      end)

    {:ok, claims}
  end

  def get_claim(_root, %{id: claim_id}, info = %{context: %{current_user: user}}) do
    queried_fields = Absinthe.Resolution.project(info) |> Enum.map(& &1.name)

    claim = Court.get_claim!(claim_id)

    with true <- claim_belongs_to_user?(claim, user),
         claim <- merge_warning_letter_if_necessary(claim, queried_fields) do
      claim = claim
      |> Map.merge(%{pdf_base64_small_claim_form: nil})
      |> Map.merge(%{pdf_base64_epo_a: nil})

      {:ok, claim}
    else
      _ -> {:error, "Unathorized"}
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

  defp claim_belongs_to_user?(claim, user) do
    case claim.user_id == user.id do
      true -> true
      _ -> {:error, "Unathorized"}
    end
  end

  defp warning_expired?(claim) do
    case claim.inserted_at < DateTime.add(DateTime.utc_now(), -60 * 60 * 24 * 7, :second) do
      true -> true
      _ -> {:error, "Claim warning phase is not yet expired"}
    end
  end

  defp can_be_updated?(claim) do
    # Either it is in warning phase and the defendant did not respond or
    # the offer made by the defendant was declined
    case claim.status_id == 1 or claim.status_id == 4 do
      true -> true
      _ -> {:error, "Claim cannot be created and sent in this phase"}
    end
  end

  defp merge_warning_letter_if_necessary(claim, queried_fields) do
    case(Enum.member?(queried_fields, "pdfBase64WarningLetter")) do
      true ->
        warning_letter_pdf = ClaimPdfGenerator.generate_warning_letter_pdf(claim)
        Map.merge(claim, %{pdf_base64_warning_letter: Base.encode64(warning_letter_pdf)})

      _ ->
        claim
    end
  end
end
