defmodule QuickcourtBackendWeb.Helpers.ChangesetErrorHelper do
  def handle_changeset_errors(changeset) do
    errors = Map.get(changeset, :errors)

    Enum.map(errors, fn {field, detail} ->
      "#{field} " <> render_detail(detail)
    end)

    # |> Enum.join()
  end

  def render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  def render_detail(message) do
    message
  end
end
