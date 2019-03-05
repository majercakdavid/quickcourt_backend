defmodule QuickcourtBackendWeb.SharedResolver do
  alias QuickcourtBackend.Shared

  def all_countries(_root, _args, _info) do
    countries = Shared.list_countries()
    {:ok, countries}
  end
end
