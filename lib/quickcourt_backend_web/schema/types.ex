defmodule QuickcourtBackendWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias QuickcourtBackendWeb.Schema.Types

  import_types(Types.UserType)
  import_types(Types.SessionType)
end
