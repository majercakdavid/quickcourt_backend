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
    new_id = :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5)
    {:ok, claim} =
      %Claim{case_number: new_id}
      |> Claim.changeset(attrs)
      |> Repo.insert()

    preloaded_claim = Repo.preload(claim, [:claimant_country, :defendant_country, :agreement_type, :issue_type])
    {:ok, preloaded_claim}
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
end
