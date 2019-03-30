alias QuickcourtBackend.Repo

alias QuickcourtBackend.Auth
alias QuickcourtBackend.Auth.User

user_emails = [
  "test@test.com"
]

user_tokens = %{}

Enum.each(user_emails, fn email ->
  attrs = %{email: email, password: "password", password_confirmation: "password"}

  %User{}
  |> User.changeset(attrs)
  |> Repo.insert()
end)

Enum.each(user_emails, fn email ->
  args = %{email: email, password: "password"}
  Auth.authenticate_user(args)
end)
