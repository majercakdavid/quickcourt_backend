defmodule QuickcourtBackend.SharedTest do
  use QuickcourtBackend.DataCase

  alias QuickcourtBackend.Shared

  describe "countries" do
    alias QuickcourtBackend.Shared.Country

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shared.create_country()

      country
    end

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Shared.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Shared.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      assert {:ok, %Country{} = country} = Shared.create_country(@valid_attrs)
      assert country.name == "some name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = Shared.update_country(country, @update_attrs)
      assert country.name == "some updated name"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_country(country, @invalid_attrs)
      assert country == Shared.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Shared.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Shared.change_country(country)
    end
  end

  describe "claim_types" do
    alias QuickcourtBackend.Shared.ClaimType

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def claim_type_fixture(attrs \\ %{}) do
      {:ok, claim_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shared.create_claim_type()

      claim_type
    end

    test "list_claim_types/0 returns all claim_types" do
      claim_type = claim_type_fixture()
      assert Shared.list_claim_types() == [claim_type]
    end

    test "get_claim_type!/1 returns the claim_type with given id" do
      claim_type = claim_type_fixture()
      assert Shared.get_claim_type!(claim_type.id) == claim_type
    end

    test "create_claim_type/1 with valid data creates a claim_type" do
      assert {:ok, %ClaimType{} = claim_type} = Shared.create_claim_type(@valid_attrs)
      assert claim_type.name == "some name"
    end

    test "create_claim_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_claim_type(@invalid_attrs)
    end

    test "update_claim_type/2 with valid data updates the claim_type" do
      claim_type = claim_type_fixture()
      assert {:ok, %ClaimType{} = claim_type} = Shared.update_claim_type(claim_type, @update_attrs)
      assert claim_type.name == "some updated name"
    end

    test "update_claim_type/2 with invalid data returns error changeset" do
      claim_type = claim_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_claim_type(claim_type, @invalid_attrs)
      assert claim_type == Shared.get_claim_type!(claim_type.id)
    end

    test "delete_claim_type/1 deletes the claim_type" do
      claim_type = claim_type_fixture()
      assert {:ok, %ClaimType{}} = Shared.delete_claim_type(claim_type)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_claim_type!(claim_type.id) end
    end

    test "change_claim_type/1 returns a claim_type changeset" do
      claim_type = claim_type_fixture()
      assert %Ecto.Changeset{} = Shared.change_claim_type(claim_type)
    end
  end

  describe "issue_types" do
    alias QuickcourtBackend.Shared.IssueType

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def issue_type_fixture(attrs \\ %{}) do
      {:ok, issue_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shared.create_issue_type()

      issue_type
    end

    test "list_issue_types/0 returns all issue_types" do
      issue_type = issue_type_fixture()
      assert Shared.list_issue_types() == [issue_type]
    end

    test "get_issue_type!/1 returns the issue_type with given id" do
      issue_type = issue_type_fixture()
      assert Shared.get_issue_type!(issue_type.id) == issue_type
    end

    test "create_issue_type/1 with valid data creates a issue_type" do
      assert {:ok, %IssueType{} = issue_type} = Shared.create_issue_type(@valid_attrs)
      assert issue_type.name == "some name"
    end

    test "create_issue_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_issue_type(@invalid_attrs)
    end

    test "update_issue_type/2 with valid data updates the issue_type" do
      issue_type = issue_type_fixture()
      assert {:ok, %IssueType{} = issue_type} = Shared.update_issue_type(issue_type, @update_attrs)
      assert issue_type.name == "some updated name"
    end

    test "update_issue_type/2 with invalid data returns error changeset" do
      issue_type = issue_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_issue_type(issue_type, @invalid_attrs)
      assert issue_type == Shared.get_issue_type!(issue_type.id)
    end

    test "delete_issue_type/1 deletes the issue_type" do
      issue_type = issue_type_fixture()
      assert {:ok, %IssueType{}} = Shared.delete_issue_type(issue_type)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_issue_type!(issue_type.id) end
    end

    test "change_issue_type/1 returns a issue_type changeset" do
      issue_type = issue_type_fixture()
      assert %Ecto.Changeset{} = Shared.change_issue_type(issue_type)
    end
  end

  describe "agreement_types" do
    alias QuickcourtBackend.Shared.AgreementType

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def agreement_type_fixture(attrs \\ %{}) do
      {:ok, agreement_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shared.create_agreement_type()

      agreement_type
    end

    test "list_agreement_types/0 returns all agreement_types" do
      agreement_type = agreement_type_fixture()
      assert Shared.list_agreement_types() == [agreement_type]
    end

    test "get_agreement_type!/1 returns the agreement_type with given id" do
      agreement_type = agreement_type_fixture()
      assert Shared.get_agreement_type!(agreement_type.id) == agreement_type
    end

    test "create_agreement_type/1 with valid data creates a agreement_type" do
      assert {:ok, %AgreementType{} = agreement_type} = Shared.create_agreement_type(@valid_attrs)
      assert agreement_type.name == "some name"
    end

    test "create_agreement_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_agreement_type(@invalid_attrs)
    end

    test "update_agreement_type/2 with valid data updates the agreement_type" do
      agreement_type = agreement_type_fixture()
      assert {:ok, %AgreementType{} = agreement_type} = Shared.update_agreement_type(agreement_type, @update_attrs)
      assert agreement_type.name == "some updated name"
    end

    test "update_agreement_type/2 with invalid data returns error changeset" do
      agreement_type = agreement_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_agreement_type(agreement_type, @invalid_attrs)
      assert agreement_type == Shared.get_agreement_type!(agreement_type.id)
    end

    test "delete_agreement_type/1 deletes the agreement_type" do
      agreement_type = agreement_type_fixture()
      assert {:ok, %AgreementType{}} = Shared.delete_agreement_type(agreement_type)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_agreement_type!(agreement_type.id) end
    end

    test "change_agreement_type/1 returns a agreement_type changeset" do
      agreement_type = agreement_type_fixture()
      assert %Ecto.Changeset{} = Shared.change_agreement_type(agreement_type)
    end
  end

  describe "resolution_types" do
    alias QuickcourtBackend.Shared.ResolutionType

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def resolution_type_fixture(attrs \\ %{}) do
      {:ok, resolution_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shared.create_resolution_type()

      resolution_type
    end

    test "list_resolution_types/0 returns all resolution_types" do
      resolution_type = resolution_type_fixture()
      assert Shared.list_resolution_types() == [resolution_type]
    end

    test "get_resolution_type!/1 returns the resolution_type with given id" do
      resolution_type = resolution_type_fixture()
      assert Shared.get_resolution_type!(resolution_type.id) == resolution_type
    end

    test "create_resolution_type/1 with valid data creates a resolution_type" do
      assert {:ok, %ResolutionType{} = resolution_type} = Shared.create_resolution_type(@valid_attrs)
      assert resolution_type.name == "some name"
    end

    test "create_resolution_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_resolution_type(@invalid_attrs)
    end

    test "update_resolution_type/2 with valid data updates the resolution_type" do
      resolution_type = resolution_type_fixture()
      assert {:ok, %ResolutionType{} = resolution_type} = Shared.update_resolution_type(resolution_type, @update_attrs)
      assert resolution_type.name == "some updated name"
    end

    test "update_resolution_type/2 with invalid data returns error changeset" do
      resolution_type = resolution_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_resolution_type(resolution_type, @invalid_attrs)
      assert resolution_type == Shared.get_resolution_type!(resolution_type.id)
    end

    test "delete_resolution_type/1 deletes the resolution_type" do
      resolution_type = resolution_type_fixture()
      assert {:ok, %ResolutionType{}} = Shared.delete_resolution_type(resolution_type)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_resolution_type!(resolution_type.id) end
    end

    test "change_resolution_type/1 returns a resolution_type changeset" do
      resolution_type = resolution_type_fixture()
      assert %Ecto.Changeset{} = Shared.change_resolution_type(resolution_type)
    end
  end
end
