defmodule QuickcourtBackendWeb.Schema.Types.UserType do
  use Absinthe.Schema.Notation

  object :user_type do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:user_type, non_null(:integer))
  end

  input_object :user_input_type do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:password_confirmation, non_null(:string))
  end

  # defmacro user_input_type() do
  #   quote do
  #     arg :email, non_null(:string)
  #     arg :password, non_null(:string)
  #     arg :password_confirmation, non_null(:string)
  #   end
  # end
end
