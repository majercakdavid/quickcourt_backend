defmodule QuickcourtBackend.Shared do
  @moduledoc """
  The Shared context.
  """

  import Ecto.Query, warn: false
  alias QuickcourtBackend.Repo

  alias QuickcourtBackend.Shared.Country
  alias QuickcourtBackend.Shared.AgreementTypeIssue

  @doc """
  Returns the list of countries.

  ## Examples

      iex> list_countries()
      [%Country{}, ...]

  """
  def list_countries do
    Repo.all(Country)
  end

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{source: %Country{}}

  """
  def change_country(%Country{} = country) do
    Country.changeset(country, %{})
  end

  alias QuickcourtBackend.Shared.ClaimType

  @doc """
  Returns the list of claim_types.

  ## Examples

      iex> list_claim_types()
      [%ClaimType{}, ...]

  """
  def list_claim_types do
    Repo.all(ClaimType)
  end

  @doc """
  Gets a single claim_type.

  Raises `Ecto.NoResultsError` if the Claim type does not exist.

  ## Examples

      iex> get_claim_type!(123)
      %ClaimType{}

      iex> get_claim_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_claim_type!(id), do: Repo.get!(ClaimType, id)

  @doc """
  Creates a claim_type.

  ## Examples

      iex> create_claim_type(%{field: value})
      {:ok, %ClaimType{}}

      iex> create_claim_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_claim_type(attrs \\ %{}) do
    %ClaimType{}
    |> ClaimType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a claim_type.

  ## Examples

      iex> update_claim_type(claim_type, %{field: new_value})
      {:ok, %ClaimType{}}

      iex> update_claim_type(claim_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_claim_type(%ClaimType{} = claim_type, attrs) do
    claim_type
    |> ClaimType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClaimType.

  ## Examples

      iex> delete_claim_type(claim_type)
      {:ok, %ClaimType{}}

      iex> delete_claim_type(claim_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_claim_type(%ClaimType{} = claim_type) do
    Repo.delete(claim_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking claim_type changes.

  ## Examples

      iex> change_claim_type(claim_type)
      %Ecto.Changeset{source: %ClaimType{}}

  """
  def change_claim_type(%ClaimType{} = claim_type) do
    ClaimType.changeset(claim_type, %{})
  end

  alias QuickcourtBackend.Shared.IssueType

  @doc """
  Returns the list of issue_types.

  ## Examples

      iex> list_issue_types()
      [%IssueType{}, ...]

  """
  def list_issue_types do
    Repo.all(IssueType)
  end

  @doc """
  Gets a single issue_type.

  Raises `Ecto.NoResultsError` if the Issue type does not exist.

  ## Examples

      iex> get_issue_type!(123)
      %IssueType{}

      iex> get_issue_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_issue_type!(id), do: Repo.get!(IssueType, id)

  @doc """
  Creates a issue_type.

  ## Examples

      iex> create_issue_type(%{field: value})
      {:ok, %IssueType{}}

      iex> create_issue_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue_type(attrs \\ %{}) do
    %IssueType{}
    |> IssueType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a issue_type.

  ## Examples

      iex> update_issue_type(issue_type, %{field: new_value})
      {:ok, %IssueType{}}

      iex> update_issue_type(issue_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_issue_type(%IssueType{} = issue_type, attrs) do
    issue_type
    |> IssueType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a IssueType.

  ## Examples

      iex> delete_issue_type(issue_type)
      {:ok, %IssueType{}}

      iex> delete_issue_type(issue_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_issue_type(%IssueType{} = issue_type) do
    Repo.delete(issue_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking issue_type changes.

  ## Examples

      iex> change_issue_type(issue_type)
      %Ecto.Changeset{source: %IssueType{}}

  """
  def change_issue_type(%IssueType{} = issue_type) do
    IssueType.changeset(issue_type, %{})
  end

  alias QuickcourtBackend.Shared.AgreementType

  @doc """
  Returns the list of agreement_types.

  ## Examples

      iex> list_agreement_types()
      [%AgreementType{}, ...]

  """
  def list_agreement_types do
    Repo.all(AgreementType)
  end

  @doc """
  Gets a single agreement_type.

  Raises `Ecto.NoResultsError` if the Agreement type does not exist.

  ## Examples

      iex> get_agreement_type!(123)
      %AgreementType{}

      iex> get_agreement_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_agreement_type!(id), do: Repo.get!(AgreementType, id)

  @doc """
  Creates a agreement_type.

  ## Examples

      iex> create_agreement_type(%{field: value})
      {:ok, %AgreementType{}}

      iex> create_agreement_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agreement_type(attrs \\ %{}) do
    %AgreementType{}
    |> AgreementType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a agreement_type.

  ## Examples

      iex> update_agreement_type(agreement_type, %{field: new_value})
      {:ok, %AgreementType{}}

      iex> update_agreement_type(agreement_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_agreement_type(%AgreementType{} = agreement_type, attrs) do
    agreement_type
    |> AgreementType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AgreementType.

  ## Examples

      iex> delete_agreement_type(agreement_type)
      {:ok, %AgreementType{}}

      iex> delete_agreement_type(agreement_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_agreement_type(%AgreementType{} = agreement_type) do
    Repo.delete(agreement_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking agreement_type changes.

  ## Examples

      iex> change_agreement_type(agreement_type)
      %Ecto.Changeset{source: %AgreementType{}}

  """
  def change_agreement_type(%AgreementType{} = agreement_type) do
    AgreementType.changeset(agreement_type, %{})
  end

  def list_agreement_type_issues do
    Repo.all(AgreementTypeIssue)
  end

  alias QuickcourtBackend.Shared.ResolutionType

  @doc """
  Returns the list of resolution_types.

  ## Examples

      iex> list_resolution_types()
      [%ResolutionType{}, ...]

  """
  def list_resolution_types do
    Repo.all(ResolutionType)
  end

  @doc """
  Gets a single resolution_type.

  Raises `Ecto.NoResultsError` if the Resolution type does not exist.

  ## Examples

      iex> get_resolution_type!(123)
      %ResolutionType{}

      iex> get_resolution_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resolution_type!(id), do: Repo.get!(ResolutionType, id)

  @doc """
  Creates a resolution_type.

  ## Examples

      iex> create_resolution_type(%{field: value})
      {:ok, %ResolutionType{}}

      iex> create_resolution_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resolution_type(attrs \\ %{}) do
    %ResolutionType{}
    |> ResolutionType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resolution_type.

  ## Examples

      iex> update_resolution_type(resolution_type, %{field: new_value})
      {:ok, %ResolutionType{}}

      iex> update_resolution_type(resolution_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resolution_type(%ResolutionType{} = resolution_type, attrs) do
    resolution_type
    |> ResolutionType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ResolutionType.

  ## Examples

      iex> delete_resolution_type(resolution_type)
      {:ok, %ResolutionType{}}

      iex> delete_resolution_type(resolution_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resolution_type(%ResolutionType{} = resolution_type) do
    Repo.delete(resolution_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resolution_type changes.

  ## Examples

      iex> change_resolution_type(resolution_type)
      %Ecto.Changeset{source: %ResolutionType{}}

  """
  def change_resolution_type(%ResolutionType{} = resolution_type) do
    ResolutionType.changeset(resolution_type, %{})
  end
end
