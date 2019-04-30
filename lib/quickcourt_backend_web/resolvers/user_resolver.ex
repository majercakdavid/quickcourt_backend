defmodule QuickcourtBackendWeb.UserResolver do
  alias QuickcourtBackend.Auth
  alias QuickcourtBackendWeb.Helpers.ChangesetErrorHelper

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
      {:ok, _} ->
        perform_login(%{email: input.email, password: input.password})

      {:error, changeset=%Ecto.Changeset{}} ->
        {:error, ChangesetErrorHelper.handle_changeset_errors(changeset)}

      {:error, message} ->
        {:error, [message]}
    end
  end

  def login_user(_root, %{input: input}, _info) do
    perform_login(input)
  end

  defp perform_login(args) do
    case Auth.login_user(args) do
      {:ok, result} ->
        {:ok, result}

      {:error, %{errors: errors}} ->
        {:error, normalize_errors(errors)}

      {:error, message} ->
        {:error, [message]}
    end
  end

  defp normalize_errors(args) do
    args
    |> Enum.map(fn {key, {message, _}} -> Atom.to_string(key) <> " " <> message end)
  end
end
