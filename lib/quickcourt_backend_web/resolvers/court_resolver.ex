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
          generated_pdf =
            Map.from_struct(claim)
            |> Enum.filter(fn {k, v} -> !Enum.member?(["__meta__", "inserted_at", "updated_at"],  Atom.to_string(k)) && v != nil end)
            |> Enum.map(fn {k, v} -> 
              case v do
                %DateTime{} -> 
                  [Atom.to_string(k) <> ": " <> to_string(v)]
                %{} ->
                  IO.inspect(k)
                  IO.inspect(v)
                  [Atom.to_string(k) <> ": " <> to_string(v.name)]
                val ->
                  [Atom.to_string(k) <> ": " <> to_string(val)] 
              end
            end)
            |> ClaimPdfGenerator.generate_pdf()

          {:ok, Map.merge(Map.from_struct(claim), %{pdf_base64: generated_pdf})}
        rescue RuntimeError -> {:error, "There was an error generating PDF document"}
        end
      _ ->
        {:error, "There was an error creating claim"}
    end
  end
end
