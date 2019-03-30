defmodule QuickcourtBackendWeb.UserResolver do
  alias QuickcourtBackend.{Auth, Guardian}

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
    Auth.create_user(input)
  end

  def login_user(_root, %{input: input}, _info) do
    with {:ok, user} <- Auth.authenticate_user(input),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end
  end
end
