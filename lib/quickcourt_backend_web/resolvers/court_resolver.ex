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
          generated_pdf = ClaimPdfGenerator.generate_pdf(claim)
          {:ok, Map.merge(Map.from_struct(claim), %{pdf_base64: generated_pdf})}
        rescue RuntimeError -> {:error, "There was an error generating PDF document"}
        end
      _ ->
        {:error, "There was an error creating claim"}
    end
  end
end
