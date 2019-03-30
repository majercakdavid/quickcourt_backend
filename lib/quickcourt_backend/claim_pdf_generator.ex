defmodule QuickcourtBackend.ClaimPdfGenerator do
  alias EEx

  def generate_small_claim_form_pdf(claim) do
    claim_list = claim_to_list(claim)

    html =
      EEx.eval_file(
        Application.app_dir(
          :quickcourt_backend,
          "priv/templates/53C.1-European_Small_Claims_Form_A.html"
        ),
        claim_list
      )

    try do
      {:ok, filename} =
        PdfGenerator.generate(html, page_size: "A4", shell_params: ["--dpi", "300"])

      {:ok, file_contents} = File.read(filename)
      Base.encode64(file_contents)
    rescue
      e ->
        IO.puts("ERROR GENERATING PDF")
        IO.inspect(e)
        throw(e)
    end
  end

  def generate_epo_a_pdf(claim) do
    claim_list = claim_to_list(claim)

    html =
      EEx.eval_file(
        Application.app_dir(:quickcourt_backend, "priv/templates/EPO_A_29072017_en.html"),
        claim_list
      )

    try do
      {:ok, filename} =
        PdfGenerator.generate(html, page_size: "A4", shell_params: ["--dpi", "300"])

      {:ok, file_contents} = File.read(filename)
      Base.encode64(file_contents)
    rescue
      e ->
        IO.puts("ERROR GENERATING PDF")
        IO.inspect(e)
        throw(e)
    end
  end

  def generate_warning_letter_pdf(claim) do
    claim_list = claim_to_list(claim)

    html =
      EEx.eval_file(
        Application.app_dir(:quickcourt_backend, "priv/templates/warning_letter_template.html"),
        claim_list
      )

    try do
      {:ok, filename} =
        PdfGenerator.generate(html, page_size: "A4", shell_params: ["--dpi", "300"])

      {:ok, file_contents} = File.read(filename)
      Base.encode64(file_contents)
    rescue
      e ->
        IO.puts("ERROR GENERATING PDF")
        IO.inspect(e)
        throw(e)
    end
  end

  defp claim_to_list(claim) do
    Map.from_struct(claim)
    |> Enum.filter(fn {k, v} ->
      !Enum.member?(["__meta__", "inserted_at", "updated_at", "user"], Atom.to_string(k)) && v != nil
    end)
    |> Enum.map(fn {k, v} ->
      new_value =
        case v do
          %DateTime{} -> to_string(v)
          %{} -> to_string(v.name)
          val -> to_string(val)
        end

      {k, new_value}
    end)
  end
end
