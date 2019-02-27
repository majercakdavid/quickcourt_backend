defmodule QuickcourtBackend.ClaimPdfGenerator do

  alias EEx


  def generate_pdf(claim) do
    claim_list = Map.from_struct(claim)
    |> Enum.filter(fn {k, v} -> !Enum.member?(["__meta__", "inserted_at", "updated_at"],  Atom.to_string(k)) && v != nil end)
    |> Enum.map(fn {k, v} -> 
      new_value = case v do
        %DateTime{} -> to_string(v)
        %{} -> to_string(v.name)
        val -> to_string(val)
      end
      {k, new_value}
    end)
    html = EEx.eval_file("./assets/53C.1-European_Small_Claims_Form_A.html", claim_list)

    try do
      {:ok, filename} =
        PdfGenerator.generate html, page_size: "A4", shell_params: ["--dpi", "300"]

      {:ok, file_contents} = File.read(filename)
      Base.encode64(file_contents)
    rescue
      e -> 
        IO.inspect(e)
        throw e
    end
  end
end
