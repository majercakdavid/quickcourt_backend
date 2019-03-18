defmodule QuickcourtBackend.Court do
  @moduledoc """
  The Court context.
  """

  import Ecto.Query, warn: false
  alias QuickcourtBackend.Repo

  alias QuickcourtBackend.Court.Claim

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
  Gets a single claim.

  Raises `Ecto.NoResultsError` if the Claim does not exist.

  ## Examples

      iex> get_claim!(123)
      %Claim{}

      iex> get_claim!(456)
      ** (Ecto.NoResultsError)

  """
  def get_claim!(id), do: Repo.get!(Claim, id)

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
        preloaded_claim =
          Repo.preload(claim, [
            :claimant_country,
            :defendant_country,
            :purchase_country,
            :delivery_country
          ])

        {:ok, preloaded_claim}

      {:error, changeset} ->
        {:error, Map.get(changeset, :errors)}
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
    claim
    |> Claim.changeset(attrs)
    |> Repo.update()
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

    agreement_types
    |> Enum.filter(fn agreement_type ->
      String.slice(agreement_type, 0..1) != "->"
    end)
    |> Enum.map(fn agreement_type ->
      code = String.slice(agreement_type, 0..1)
      label = String.slice(agreement_type, 3..-1)
      %{code: code, label: label}
    end)
  end

  @doc """
  Returns the list of possible agreement_type_issues according
  to passed in agreement type.
  """
  def list_agreement_type_issues(agreement_type) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.agreement_type_issue,
          where: cr.agreement_type == ^agreement_type,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{label: claim_rule.agreement_type_issue}
    end)
  end

  @doc """
  Returns the list of possible circumstances invoked according
  to passed in agreement type and agreement type issue.
  """
  def list_circumstances_invoked(agreement_type, agreement_type_issue) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.circumstance_invoked,
          where:
            cr.agreement_type == ^agreement_type and
              cr.agreement_type_issue == ^agreement_type_issue,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue,
            circumstance_invoked: cr.circumstance_invoked,
            cicumstance_invoked_code: cr.cicumstance_invoked_code
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{
        label: claim_rule.circumstance_invoked,
        code: claim_rule.cicumstance_invoked_code
      }
    end)
  end

  @doc """
  Returns the list of possible first resolutions according
  to passed in agreement type, agreement type issue and circumstances invoked.
  """
  def list_first_resolutions(agreement_type, agreement_type_issue, circumstance_invoked) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.first_resolution,
          where:
            cr.agreement_type == ^agreement_type and
              cr.agreement_type_issue == ^agreement_type_issue and
              cr.circumstance_invoked == ^circumstance_invoked,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue,
            circumstance_invoked: cr.circumstance_invoked,
            cicumstance_invoked_code: cr.cicumstance_invoked_code,
            first_resolution: cr.first_resolution,
            first_resolution_code: cr.first_resolution_code
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{
        label: claim_rule.first_resolution,
        code: claim_rule.first_resolution_code
      }
    end)
  end

  @doc """
  Returns the list of possible first resolutions according
  to passed in agreement type, agreement type issue and circumstances invoked.
  """
  def list_second_resolutions(agreement_type, agreement_type_issue, circumstance_invoked) do
    claim_rules =
      Repo.all(
        from cr in "claim_rules",
          distinct: cr.second_resolution,
          where:
            cr.agreement_type == ^agreement_type and
              cr.agreement_type_issue == ^agreement_type_issue and
              cr.circumstance_invoked == ^circumstance_invoked,
          select: %{
            agreement_type: cr.agreement_type,
            agreement_type_issue: cr.agreement_type_issue,
            circumstance_invoked: cr.circumstance_invoked,
            cicumstance_invoked_code: cr.cicumstance_invoked_code,
            second_resolution: cr.second_resolution,
            second_resolution_code: cr.second_resolution_code
          }
      )

    claim_rules
    |> Enum.map(fn claim_rule ->
      %{
        label: claim_rule.second_resolution,
        code: claim_rule.second_resolution_code
      }
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
end
