defmodule QuickcourtBackend.CourtTest do
  use QuickcourtBackend.DataCase

  alias QuickcourtBackend.Court

  describe "claims" do
    alias QuickcourtBackend.Court.Claim

    @valid_attrs %{is_business: true}
    @update_attrs %{is_business: false}
    @invalid_attrs %{is_business: nil}

    def claim_fixture(attrs \\ %{}) do
      {:ok, claim} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Court.create_claim()

      claim
    end

    test "list_claims/0 returns all claims" do
      claim = claim_fixture()
      assert Court.list_claims() == [claim]
    end

    test "get_claim!/1 returns the claim with given id" do
      claim = claim_fixture()
      assert Court.get_claim!(claim.id) == claim
    end

    test "create_claim/1 with valid data creates a claim" do
      assert {:ok, %Claim{} = claim} = Court.create_claim(@valid_attrs)
      assert claim.is_business == true
    end

    test "create_claim/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Court.create_claim(@invalid_attrs)
    end

    test "update_claim/2 with valid data updates the claim" do
      claim = claim_fixture()
      assert {:ok, %Claim{} = claim} = Court.update_claim(claim, @update_attrs)
      assert claim.is_business == false
    end

    test "update_claim/2 with invalid data returns error changeset" do
      claim = claim_fixture()
      assert {:error, %Ecto.Changeset{}} = Court.update_claim(claim, @invalid_attrs)
      assert claim == Court.get_claim!(claim.id)
    end

    test "delete_claim/1 deletes the claim" do
      claim = claim_fixture()
      assert {:ok, %Claim{}} = Court.delete_claim(claim)
      assert_raise Ecto.NoResultsError, fn -> Court.get_claim!(claim.id) end
    end

    test "change_claim/1 returns a claim changeset" do
      claim = claim_fixture()
      assert %Ecto.Changeset{} = Court.change_claim(claim)
    end
  end

  describe "claim_rules" do
    alias QuickcourtBackend.Court.ClaimRule

    @valid_attrs %{
      agreement_type: "some agreement_type",
      agreement_type_issue: "some agreement_type_issue",
      circumstances_invoked_code: "some circumstances_invoked_code",
      circumstances_invoked: "some circumstances_invoked",
      first_resolution: "some first_resolution",
      first_resolution_code: "some first_resolution_code",
      second_resolution: "some second_resolution",
      second_resolution_code: "some second_resolution_code"
    }
    @update_attrs %{
      agreement_type: "some updated agreement_type",
      agreement_type_issue: "some updated agreement_type_issue",
      circumstances_invoked_code: "some updated circumstances_invoked_code",
      circumstances_invoked: "some updated circumstances_invoked",
      first_resolution: "some updated first_resolution",
      first_resolution_code: "some updated first_resolution_code",
      second_resolution: "some updated second_resolution",
      second_resolution_code: "some updated second_resolution_code"
    }
    @invalid_attrs %{
      agreement_type: nil,
      agreement_type_issue: nil,
      circumstances_invoked_code: nil,
      circumstances_invoked: nil,
      first_resolution: nil,
      first_resolution_code: nil,
      second_resolution: nil,
      second_resolution_code: nil
    }

    def claim_rule_fixture(attrs \\ %{}) do
      {:ok, claim_rule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Court.create_claim_rule()

      claim_rule
    end

    test "list_claim_rules/0 returns all claim_rules" do
      claim_rule = claim_rule_fixture()
      assert Court.list_claim_rules() == [claim_rule]
    end

    test "get_claim_rule!/1 returns the claim_rule with given id" do
      claim_rule = claim_rule_fixture()
      assert Court.get_claim_rule!(claim_rule.id) == claim_rule
    end

    test "create_claim_rule/1 with valid data creates a claim_rule" do
      assert {:ok, %ClaimRule{} = claim_rule} = Court.create_claim_rule(@valid_attrs)
      assert claim_rule.agreement_type == "some agreement_type"
      assert claim_rule.agreement_type_issue == "some agreement_type_issue"
      assert claim_rule.circumstances_invoked_code == "some circumstances_invoked_code"
      assert claim_rule.circumstances_invoked == "some circumstances_invoked"
      assert claim_rule.first_resolution == "some first_resolution"
      assert claim_rule.first_resolution_code == "some first_resolution_code"
      assert claim_rule.second_resolution == "some second_resolution"
      assert claim_rule.second_resolution_code == "some second_resolution_code"
    end

    test "create_claim_rule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Court.create_claim_rule(@invalid_attrs)
    end

    test "update_claim_rule/2 with valid data updates the claim_rule" do
      claim_rule = claim_rule_fixture()
      assert {:ok, %ClaimRule{} = claim_rule} = Court.update_claim_rule(claim_rule, @update_attrs)
      assert claim_rule.agreement_type == "some updated agreement_type"
      assert claim_rule.agreement_type_issue == "some updated agreement_type_issue"
      assert claim_rule.circumstances_invoked_code == "some updated circumstances_invoked_code"
      assert claim_rule.circumstances_invoked == "some updated circumstances_invoked"
      assert claim_rule.first_resolution == "some updated first_resolution"
      assert claim_rule.first_resolution_code == "some updated first_resolution_code"
      assert claim_rule.second_resolution == "some updated second_resolution"
      assert claim_rule.second_resolution_code == "some updated second_resolution_code"
    end

    test "update_claim_rule/2 with invalid data returns error changeset" do
      claim_rule = claim_rule_fixture()
      assert {:error, %Ecto.Changeset{}} = Court.update_claim_rule(claim_rule, @invalid_attrs)
      assert claim_rule == Court.get_claim_rule!(claim_rule.id)
    end

    test "delete_claim_rule/1 deletes the claim_rule" do
      claim_rule = claim_rule_fixture()
      assert {:ok, %ClaimRule{}} = Court.delete_claim_rule(claim_rule)
      assert_raise Ecto.NoResultsError, fn -> Court.get_claim_rule!(claim_rule.id) end
    end

    test "change_claim_rule/1 returns a claim_rule changeset" do
      claim_rule = claim_rule_fixture()
      assert %Ecto.Changeset{} = Court.change_claim_rule(claim_rule)
    end
  end

  describe "claim_statuses" do
    alias QuickcourtBackend.Court.ClaimStatus

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def claim_status_fixture(attrs \\ %{}) do
      {:ok, claim_status} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Court.create_claim_status()

      claim_status
    end

    test "list_claim_statuses/0 returns all claim_statuses" do
      claim_status = claim_status_fixture()
      assert Court.list_claim_statuses() == [claim_status]
    end

    test "get_claim_status!/1 returns the claim_status with given id" do
      claim_status = claim_status_fixture()
      assert Court.get_claim_status!(claim_status.id) == claim_status
    end

    test "create_claim_status/1 with valid data creates a claim_status" do
      assert {:ok, %ClaimStatus{} = claim_status} = Court.create_claim_status(@valid_attrs)
      assert claim_status.name == "some name"
    end

    test "create_claim_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Court.create_claim_status(@invalid_attrs)
    end

    test "update_claim_status/2 with valid data updates the claim_status" do
      claim_status = claim_status_fixture()

      assert {:ok, %ClaimStatus{} = claim_status} =
               Court.update_claim_status(claim_status, @update_attrs)

      assert claim_status.name == "some updated name"
    end

    test "update_claim_status/2 with invalid data returns error changeset" do
      claim_status = claim_status_fixture()
      assert {:error, %Ecto.Changeset{}} = Court.update_claim_status(claim_status, @invalid_attrs)
      assert claim_status == Court.get_claim_status!(claim_status.id)
    end

    test "delete_claim_status/1 deletes the claim_status" do
      claim_status = claim_status_fixture()
      assert {:ok, %ClaimStatus{}} = Court.delete_claim_status(claim_status)
      assert_raise Ecto.NoResultsError, fn -> Court.get_claim_status!(claim_status.id) end
    end

    test "change_claim_status/1 returns a claim_status changeset" do
      claim_status = claim_status_fixture()
      assert %Ecto.Changeset{} = Court.change_claim_status(claim_status)
    end
  end
end
