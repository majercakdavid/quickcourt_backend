defmodule QuickcourtBackendWeb.UserResolver do
  alias QuickcourtBackend.Auth

  @type user_context() :: %{current_user: Auth.User}

  def all_users(_root, _args, %{context: _context}) do
    users = Auth.list_users()
    {:ok, users}
  end

  @spec get_user(any(), any(), user_context()) :: any()
  def get_user(_root, _args, %{context: %{current_user: user}}) do
    {:ok, Auth.get_user!(user.id)}
  end

  def register_user(_root, %{input: input}, _info) do
    case Auth.create_user(input) do
      {:ok, user} ->
        {:ok, user}

      {:error, %{errors: errors}} ->
        {:error, normalize_errors(errors)}
    end
  end

  def login_user(_root, %{input: input}, _info) do
    case Auth.login_user(input) do
      {:ok, result} ->
        {:ok, result}

      {:error, %{errors: errors}} ->
        {:error, normalize_errors(errors)}
    end
  end

  defp normalize_errors(args) do
    args
    |> Enum.map(fn {key, {message, _}} -> {key, message} end)
    |> inspect
  end
end
