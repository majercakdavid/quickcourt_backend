defmodule QuickcourtBackendWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  def call(resolution, user_type) do
    with %{current_user: current_user} <- resolution.context,
         true <- correct_user_type(current_user, user_type) do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Unathorized"})
    end
  end

  defp correct_user_type(%{}, :any), do: true
  defp correct_user_type(%{user_type: user_type}, user_type), do: true
  defp correct_user_type(_, _), do: false
end
