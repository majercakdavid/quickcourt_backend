defmodule QuickcourtBackendWeb.CourtResolver do
  alias QuickcourtBackend.Court
  alias QuickcourtBackend.ClaimPdfGenerator
  alias QuickcourtBackend.Email
  alias QuickcourtBackendWeb.Helpers.ChangesetErrorHelper

  @type user_context() :: %{current_user: Auth.User}

  def all_claims(_root, _args, _info) do
    claims = Court.list_claims()
    {:ok, claims}
  end

  @spec update_claim_status(any(), any(), user_context()) :: any()
  def update_claim_status(_root, %{id: claim_id}, info = %{context: %{current_user: user}}) do
    queried_fields = Absinthe.Resolution.project(info) |> Enum.map(& &1.name)

    with claim <- Court.get_claim!(claim_id),
         true <- claim_belongs_to_user?(claim, user),
         true <- warning_expired?(claim),
         true <- can_be_updated?(claim),
         {:ok, new_claim} <- Court.update_claim(claim, %{claim_status_id: 5}),
         claim_map <- Map.from_struct(new_claim),
         {:ok, claim_map} <- merge_claim_rules(claim_map),
         {:ok, claim_map} <- merge_warning_letter_if_necessary(claim_map, queried_fields),
         {:ok, claim_map} <- merge_small_claim_form_if_necessary(claim_map, queried_fields),
         {:ok, claim_map} <- merge_epo_a_if_necessary(claim_map, queried_fields) do
      {:ok, claim_map}
    else
      {:error, changeset = %Ecto.Changeset{}} ->
        {:error, ChangesetErrorHelper.handle_changeset_errors(changeset)}

      {:error, info} ->
        {:error, info}
    end
  end

  @spec create_claim(any(), any(), user_context()) :: any()
  def create_claim(_root, args, info = %{context: %{current_user: user}}) do
    queried_fields = Absinthe.Resolution.project(info) |> Enum.map(& &1.name)

    case args
         |> Map.merge(%{user_id: user.id, claim_status_id: 1})
         |> Court.create_claim() do
      {:ok, claim} ->
        with claim_map <- Map.from_struct(claim),
             {:ok, claim_map} <- merge_claim_rules(claim_map),
             {:ok, claim_map} <- merge_warning_letter(claim_map),
             {:ok, claim_map} <- merge_small_claim_form_if_necessary(claim_map, queried_fields),
             {:ok, claim_map} <- merge_epo_a_if_necessary(claim_map, queried_fields) do
          Email.send_warning_letter_defendant(
            claim_map,
            claim_map.pdf_base64_warning_letter
          )

          Email.send_warning_letter_claimant(
            claim_map,
            claim_map.pdf_base64_warning_letter
          )

          claim_map =
            claim_map
            |> Map.replace!(
              :pdf_base64_warning_letter,
              Base.encode64(claim_map.pdf_base64_warning_letter)
            )

          {:ok, claim_map}
        else
          {:error, e} -> {:error, e}
        end

      {:error, changeset} ->
        {:error, ChangesetErrorHelper.handle_changeset_errors(changeset)}
    end
  end

  def get_user_claims(_root, _args, info = %{context: %{current_user: user}}) do
    queried_fields = Absinthe.Resolution.project(info) |> Enum.map(& &1.name)

    claims =
      Court.list_user_claims(user.id)
      |> Enum.map(fn claim ->
        with claim_map <- Map.from_struct(claim),
             {:ok, claim_map} <- merge_claim_rules(claim_map),
             {:ok, claim_map} <- merge_warning_letter_if_necessary(claim_map, queried_fields),
             {:ok, claim_map} <- merge_small_claim_form_if_necessary(claim_map, queried_fields),
             {:ok, claim_map} <- merge_epo_a_if_necessary(claim_map, queried_fields) do
          claim_map
          # |> Map.merge(%{pdf_base64_small_claim_form: nil})
          # |> Map.merge(%{pdf_base64_epo_a: nil})
        else
          {:error, e} -> {:error, e}
        end
      end)

    {:ok, claims}
  end

  def get_claim(_root, %{id: claim_id}, info = %{context: %{current_user: user}}) do
    queried_fields = Absinthe.Resolution.project(info) |> Enum.map(& &1.name)

    claim = Court.get_claim!(claim_id)

    with true <- claim_belongs_to_user?(claim, user),
         claim_map <- Map.from_struct(claim),
         {:ok, claim_map} <- merge_claim_rules(claim_map),
         {:ok, claim_map} <- merge_warning_letter_if_necessary(claim_map, queried_fields),
         {:ok, claim_map} <- merge_small_claim_form_if_necessary(claim_map, queried_fields),
         {:ok, claim_map} <- merge_epo_a_if_necessary(claim_map, queried_fields) do
      {:ok, claim_map}
    else
      {:error, e} ->
        {:error, e}
    end
  end

  def all_agreement_types(_root, _args, _info) do
    agreement_types = Court.list_agreement_types()
    {:ok, agreement_types}
  end

  def all_agreement_type_issues(_root, %{agreement_type_label: agreement_type_label}, _info) do
    agreement_type_issues = Court.list_agreement_type_issues(agreement_type_label)
    {:ok, agreement_type_issues}
  end

  def get_claimant_description(
        _root,
        %{
          agreement_type_label: agreement_type_label,
          agreement_type_issue_label: agreement_type_issue_label
        },
        _info
      ) do
    claimant_description =
      Court.get_claimant_description(agreement_type_label, agreement_type_issue_label)

    {:ok, claimant_description}
  end

  def get_defendant_description(
        _root,
        %{
          agreement_type_label: agreement_type_label,
          agreement_type_issue_label: agreement_type_issue_label
        },
        _info
      ) do
    defendant_description =
      Court.get_defendant_description(agreement_type_label, agreement_type_issue_label)

    {:ok, defendant_description}
  end

  def all_circumstances_invoked(
        _root,
        %{
          agreement_type_label: agreement_type_label,
          agreement_type_issue_label: agreement_type_issue_label
        },
        _info
      ) do
    agreement_type_issues =
      Court.list_circumstances_invoked(agreement_type_label, agreement_type_issue_label)

    {:ok, agreement_type_issues}
  end

  def all_first_resolutions(
        _root,
        %{
          agreement_type_label: agreement_type_label,
          agreement_type_issue_label: agreement_type_issue_label,
          circumstances_invoked_label: circumstances_invoked_label
        },
        _info
      ) do
    first_resolutions =
      Court.list_first_resolutions(
        agreement_type_label,
        agreement_type_issue_label,
        circumstances_invoked_label
      )

    {:ok, first_resolutions}
  end

  def all_second_resolutions(
        _root,
        %{
          agreement_type_label: agreement_type_label,
          agreement_type_issue_label: agreement_type_issue_label,
          circumstances_invoked_label: circumstances_invoked_label,
          first_resolution_label: first_resolution_label
        },
        _info
      ) do
    second_resolutions =
      Court.list_second_resolutions(
        agreement_type_label,
        agreement_type_issue_label,
        circumstances_invoked_label,
        first_resolution_label
      )

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
    case claim.claim_status_id == 1 or claim.claim_status_id == 4 do
      true -> true
      _ -> {:error, "Claim cannot be created and sent in this phase"}
    end
  end

  defp merge_claim_rules(claim_map) do
    with [cr | []] <-
           QuickcourtBackend.Court.get_claim_rules_by_labels(
             claim_map.agreement_type_label,
             claim_map.agreement_type_issue_label,
             claim_map.circumstances_invoked_label,
             claim_map.first_resolution_label,
             claim_map.second_resolution_label
           ) do
      claim_map =
        claim_map
        |> Map.put(:agreement_type, %{
          label: String.slice(cr.agreement_type, 3..-1),
          code: cr.agreement_type
        })
        |> Map.put(:agreement_type_issue, %{
          label: claim_map.agreement_type_issue_label,
          code: cr.agreement_type_issue
        })
        |> Map.put(:circumstances_invoked, %{
          label: claim_map.circumstances_invoked_label,
          code: cr.circumstances_invoked
        })
        |> Map.put(:first_resolution, %{
          label: claim_map.first_resolution_label,
          code: cr.first_resolution
        })

      claim_map =
        case claim_map.second_resolution_label != nil do
          true ->
            Map.put(claim_map, :second_resolution, %{
              label: claim_map.second_resolution_label,
              code: cr.second_resolution
            })

          _ ->
            Map.put(claim_map, :second_resolution, nil)
        end

      {:ok, claim_map}
    else
      _ -> {:error, "There was an error retrieving claim rules"}
    end
  end

  defp merge_small_claim_form_if_necessary(claim_map, queried_fields) do
    case(Enum.member?(queried_fields, "pdfBase64SmallClaimForm")) do
      true ->
        with {:ok, small_claim_form_pdf} <-
               ClaimPdfGenerator.generate_small_claim_form_pdf(claim_map) do
          {:ok,
           Map.merge(claim_map, %{
             pdf_base64_small_claim_form: Base.encode64(small_claim_form_pdf)
           })}
        else
          e -> {:error, "There was an error generating small claim form: " <> inspect(e)}
        end

      _ ->
        {:ok, claim_map}
    end
  end

  defp merge_epo_a_if_necessary(claim_map, queried_fields) do
    case(Enum.member?(queried_fields, "pdfBase64EpoA")) do
      true ->
        with {:ok, epo_a_pdf} <- ClaimPdfGenerator.generate_epo_a_pdf(claim_map) do
          {:ok, Map.merge(claim_map, %{pdf_base64_epo_a: Base.encode64(epo_a_pdf)})}
        else
          e -> {:error, "There was an error generating small claim form. " <> inspect(e)}
        end

      _ ->
        {:ok, claim_map}
    end
  end

  defp merge_warning_letter_if_necessary(claim_map, queried_fields) do
    case(Enum.member?(queried_fields, "pdfBase64WarningLetter")) do
      true ->
        with {:ok, claim_map} <- merge_warning_letter(claim_map) do
          claim_map =
            Map.replace!(
              claim_map,
              :pdf_base64_warning_letter,
              Base.encode64(claim_map.pdf_base64_warning_letter)
            )

          {:ok, claim_map}
        else
          e -> e
        end

      _ ->
        {:ok, claim_map}
    end
  end

  defp merge_warning_letter(claim_map) do
    with {:ok, warning_letter_pdf} <- ClaimPdfGenerator.generate_warning_letter_pdf(claim_map) do
      {:ok, Map.merge(claim_map, %{pdf_base64_warning_letter: warning_letter_pdf})}
    else
      e -> {:error, "There was an error generating warning letter. " <> inspect(e)}
    end
  end
end
