defmodule QuickcourtBackend.Court do
  @moduledoc """
  The Court context.
  """

  import Ecto.Query, warn: false
  alias QuickcourtBackend.Repo

  alias QuickcourtBackend.Court.Claim
  alias QuickcourtBackend.Court.ClaimStatus

  @doc """
  Returns the list of claims.

  ## Examples

      iex> list_claims()
      [%Claim{}, ...]

  """
  def list_claims do
    Repo.all(Claim)
  end

  @doc """
  Returns the list of user's claims.

  ## Examples

      iex> list_user_claims()
      [%Claim{}, ...]

  """
  def list_user_claims(user_id) do
    Repo.all(
      from claim in Claim,
        preload: [
          :claimant_country,
          :defendant_country,
          :purchase_country,
          :delivery_country,
          :claim_status,
          :user
        ],
        where: claim.user_id == ^user_id
    )
  end

  @doc """
  Gets a single claim.

  Raises `Ecto.NoResultsError` if the Claim does not exist.

  ## Examples

      iex> get_claim!(123)
      %Claim{}

      iex> get_claim!(456)
      ** (Ecto.NoResultsError)

  """
  def get_claim!(id),
    do:
      Repo.get!(Claim, id)
      |> Repo.preload([
        :claimant_country,
        :defendant_country,
        :purchase_country,
        :delivery_country,
        :claim_status,
        :user
      ])

  @doc """
  Creates a claim.

  ## Examples

      iex> create_claim(%{field: value})
      {:ok, %Claim{}}

      iex> create_claim(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_claim(attrs \\ %{}) do
    new_id = :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)

    claim_res =
      %Claim{case_number: new_id}
      |> Claim.changeset(attrs)
      |> Repo.insert()

    case claim_res do
      {:ok, claim} ->
        claim =
          Repo.preload(claim, [
            :claimant_country,
            :defendant_country,
            :purchase_country,
            :delivery_country,
            :claim_status,
            :user
          ])

        {:ok, claim}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a claim.

  ## Examples

      iex> update_claim(claim, %{field: new_value})
      {:ok, %Claim{}}

      iex> update_claim(claim, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_claim(%Claim{} = claim, attrs) do
    with {:ok, claim} <- claim |> Claim.changeset(attrs) |> Repo.update(),
         claim <-
           Repo.preload(
             claim,
             [
               :claimant_country,
               :defendant_country,
               :purchase_country,
               :delivery_country,
               :claim_status,
               :user
             ],
             force: true
           ) do
      {:ok, claim}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a Claim.

  ## Examples

      iex> delete_claim(claim)
      {:ok, %Claim{}}

      iex> delete_claim(claim)
      {:error, %Ecto.Changeset{}}

  """
  def delete_claim(%Claim{} = claim) do
    Repo.delete(claim)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking claim changes.

  ## Examples

      iex> change_claim(claim)
      %Ecto.Changeset{source: %Claim{}}

  """
  def change_claim(%Claim{} = claim) do
    Claim.changeset(claim, %{})
  end

  @doc """
  Returns the list of claims for which the warning status has expired.

  ## Examples

      iex> expired_warning_claims()
      [%Claim{}, ...]

  """
  def expired_warning_claims do
    {:ok, expiry_date} =
      DateTime.from_unix(DateTime.to_unix(DateTime.utc_now()) - 60 * 60 * 24 * 15)

    expiry_naive_date = DateTime.to_naive(expiry_date)

    Repo.all(
      from claim in Claim,
        left_join: claim_status in assoc(claim, :claim_status),
        preload: [claim_status: claim_status],
        where:
          claim.inserted_at < ^expiry_naive_date and
            (claim.warning_expiration_email_sent_on < ago(6, "day") or
               is_nil(claim.warning_expiration_email_sent_on)) and
            (claim_status.name == "WARNING_SENT" or claim_status.name == "OFFER_DECLINED")
    )
  end

  alias QuickcourtBackend.Court.ClaimRule

  @doc """
  Returns the list of claim_rules.

  ## Examples

      iex> list_claim_rules()
      [%ClaimRule{}, ...]

  """
  def list_claim_rules do
    Repo.all(ClaimRule)
  end

  @doc """
  Returns the list of possible agreement_types.
  """
  def list_agreement_types do
    agreement_types =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.agreement_type,
          select: cr.agreement_type
      )
      |> Enum.filter(fn agreement_type ->
        String.slice(agreement_type, 0..1) != "->"
      end)

    agreement_types
    |> Enum.map(fn agreement_type ->
      # String.slice(agreement_type, 3..-1)
      label = agreement_type
      %{code: agreement_type, label: label}
    end)
  end

  @doc """
  Returns the list of possible agreement_type_issues according
  to passed in agreement type.
  """
  def list_agreement_type_issues(agreement_type_label) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.agreement_type_issue,
          where: cr.agreement_type == ^agreement_type_label,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{code: claim_rule.agreement_type_issue, label: claim_rule.agreement_type_issue}
    end)
  end

  def get_claimant_description(agreement_type_label, agreement_type_issue_label) do
    Repo.one(
      from cr in "claim_rules",
        where:
          cr.agreement_type == ^agreement_type_label and
            cr.agreement_type_issue == ^agreement_type_issue_label,
        select: %{
          agreement_type: cr.agreement_type,
          agreement_type_issue: cr.agreement_type_issue,
          claimant_description: cr.claimant_description
        },
        limit: 1
    )
    |> Map.get(:claimant_description)
  end

  def get_defendant_description(agreement_type_label, agreement_type_issue_label) do
    Repo.one(
      from cr in "claim_rules",
        where:
          cr.agreement_type == ^agreement_type_label and
            cr.agreement_type_issue == ^agreement_type_issue_label,
        select: %{
          agreement_type: cr.agreement_type,
          agreement_type_issue: cr.agreement_type_issue,
          defendant_description: cr.defendant_description
        },
        limit: 1
    )
    |> Map.get(:defendant_description)
  end

  @doc """
  Returns the list of possible circumstances invoked according
  to passed in agreement type and agreement type issue.
  """
  def list_circumstances_invoked(agreement_type_label, agreement_type_issue_label) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.circumstances_invoked,
          where:
            cr.agreement_type == ^agreement_type_label and
              cr.agreement_type_issue == ^agreement_type_issue_label,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue,
            circumstances_invoked: cr.circumstances_invoked,
            circumstances_invoked_code: cr.circumstances_invoked_code
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{code: claim_rule.circumstances_invoked_code, label: claim_rule.circumstances_invoked}
    end)
  end

  @doc """
  Returns the list of possible first resolutions according
  to passed in agreement type, agreement type issue and circumstances invoked.
  """
  def list_first_resolutions(
        agreement_type_label,
        agreement_type_issue_label,
        circumstances_invoked_label
      ) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.first_resolution,
          where:
            cr.agreement_type == ^agreement_type_label and
              cr.agreement_type_issue == ^agreement_type_issue_label and
              cr.circumstances_invoked == ^circumstances_invoked_label,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue,
            circumstances_invoked: cr.circumstances_invoked,
            circumstances_invoked_code: cr.circumstances_invoked_code,
            first_resolution: cr.first_resolution,
            first_resolution_code: cr.first_resolution_code
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{code: claim_rule.first_resolution_code, label: claim_rule.first_resolution}
    end)
  end

  @doc """
  Returns the list of possible first resolutions according
  to passed in agreement type, agreement type issue and circumstances invoked.
  """
  def list_second_resolutions(
        agreement_type_label,
        agreement_type_issue_label,
        circumstances_invoked_label,
        first_resolution_label
      ) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.second_resolution,
          where:
            cr.agreement_type == ^agreement_type_label and
              cr.agreement_type_issue == ^agreement_type_issue_label and
              cr.circumstances_invoked == ^circumstances_invoked_label and
              cr.first_resolution == ^first_resolution_label,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue,
            circumstances_invoked: cr.circumstances_invoked,
            circumstances_invoked_code: cr.circumstances_invoked_code,
            second_resolution: cr.second_resolution,
            second_resolution_code: cr.second_resolution_code
          }
      )

    claim_rules
    # If the second resolution is missing print out empty array instead of values set to nil
    |> Enum.filter(fn claim_rule -> claim_rule.second_resolution != nil end)
    |> Enum.map(fn claim_rule ->
      %{code: claim_rule.second_resolution_code, label: claim_rule.second_resolution}
    end)
  end

  @doc """
  Gets a single claim_rule.

  Raises `Ecto.NoResultsError` if the Claim rule does not exist.

  ## Examples

      iex> get_claim_rule!(123)
      %ClaimRule{}

      iex> get_claim_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_claim_rule!(id), do: Repo.get!(ClaimRule, id)

  @doc """
  Returns the list of claim_rules according to the provided codes.

  ## Examples

      iex> list_claim_rules()
      [%ClaimRule{}, ...]

  """
  def get_claim_rules_by_labels(
        agreement_type_label,
        agreement_type_issue_label,
        circumstances_invoked_label,
        first_resolution_label,
        nil
      ) do
    Repo.all(
      from cr in ClaimRule,
        where:
          cr.agreement_type == ^agreement_type_label and
            cr.agreement_type_issue == ^agreement_type_issue_label and
            cr.circumstances_invoked == ^circumstances_invoked_label and
            cr.first_resolution == ^first_resolution_label
    )
  end

  def get_claim_rules_by_labels(
        agreement_type_label,
        agreement_type_issue_label,
        circumstances_invoked_label,
        first_resolution_label,
        second_resolution_label
      ) do
    Repo.all(
      from cr in ClaimRule,
        where:
          cr.agreement_type == ^agreement_type_label and
            cr.agreement_type_issue == ^agreement_type_issue_label and
            cr.circumstances_invoked == ^circumstances_invoked_label and
            cr.first_resolution == ^first_resolution_label and
            cr.second_resolution == ^second_resolution_label
    )
  end

  @doc """
  Creates a claim_rule.

  ## Examples

      iex> create_claim_rule(%{field: value})
      {:ok, %ClaimRule{}}

      iex> create_claim_rule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_claim_rule(attrs \\ %{}) do
    %ClaimRule{}
    |> ClaimRule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a claim_rule.

  ## Examples

      iex> update_claim_rule(claim_rule, %{field: new_value})
      {:ok, %ClaimRule{}}

      iex> update_claim_rule(claim_rule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_claim_rule(%ClaimRule{} = claim_rule, attrs) do
    claim_rule
    |> ClaimRule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClaimRule.

  ## Examples

      iex> delete_claim_rule(claim_rule)
      {:ok, %ClaimRule{}}

      iex> delete_claim_rule(claim_rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_claim_rule(%ClaimRule{} = claim_rule) do
    Repo.delete(claim_rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking claim_rule changes.

  ## Examples

      iex> change_claim_rule(claim_rule)
      %Ecto.Changeset{source: %ClaimRule{}}

  """
  def change_claim_rule(%ClaimRule{} = claim_rule) do
    ClaimRule.changeset(claim_rule, %{})
  end

  alias QuickcourtBackend.Court.ClaimStatus

  @doc """
  Returns the list of claim_statuses.

  ## Examples

      iex> list_claim_statuses()
      [%ClaimStatus{}, ...]

  """
  def list_claim_statuses do
    Repo.all(ClaimStatus)
  end

  @doc """
  Gets a single claim_status.

  Raises `Ecto.NoResultsError` if the Claim status does not exist.

  ## Examples

      iex> get_claim_status!(123)
      %ClaimStatus{}

      iex> get_claim_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_claim_status!(id), do: Repo.get!(ClaimStatus, id)

  @doc """
  Creates a claim_status.

  ## Examples

      iex> create_claim_status(%{field: value})
      {:ok, %ClaimStatus{}}

      iex> create_claim_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_claim_status(attrs \\ %{}) do
    %ClaimStatus{}
    |> ClaimStatus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a claim_status.

  ## Examples

      iex> update_claim_status(claim_status, %{field: new_value})
      {:ok, %ClaimStatus{}}

      iex> update_claim_status(claim_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_claim_status(%ClaimStatus{} = claim_status, attrs) do
    claim_status
    |> ClaimStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClaimStatus.

  ## Examples

      iex> delete_claim_status(claim_status)
      {:ok, %ClaimStatus{}}

      iex> delete_claim_status(claim_status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_claim_status(%ClaimStatus{} = claim_status) do
    Repo.delete(claim_status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking claim_status changes.

  ## Examples

      iex> change_claim_status(claim_status)
      %Ecto.Changeset{source: %ClaimStatus{}}

  """
  def change_claim_status(%ClaimStatus{} = claim_status) do
    ClaimStatus.changeset(claim_status, %{})
  end
end
