defmodule QuickcourtBackendWeb.Schema.Types.SessionType do
  use Absinthe.Schema.Notation

  object :session_type do
    field(:token, non_null(:string))
    field(:user, non_null(:user_type))
  end

  input_object :session_input_type do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  # defmacro session_input_type() do
  #     quote do
  #         arg :email, :string
  #         arg :password, :string
  #     end
  # end
end
