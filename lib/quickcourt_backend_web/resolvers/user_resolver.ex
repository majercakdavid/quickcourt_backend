defmodule QuickcourtBackendWeb.UserResolver do
    alias QuickcourtBackend.{Auth, Guardian}

    def all_users(_root, _args, _info) do
        users = Auth.list_users()
        {:ok, users}
    end

    def register_user(_root, %{input: input}, _info) do
        Auth.create_user(input)
    end

    def login_user(_root, %{input: input}, _info) do
        with {:ok, user} <- Auth.authenticate_user(input), {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
            {:ok, %{token: jwt_token, user: user}}
        end
    end
end  