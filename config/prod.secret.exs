use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :quickcourt_backend, QuickcourtBackendWeb.Endpoint,
  secret_key_base: "7t3J7D4Hqv0XqyX2N0NNqq2z6GoJyR/s/PVKVoCiMf+6MO3vlgCSI9Z4Y0jiiJwf"

# Configure your database
config :quickcourt_backend, QuickcourtBackend.Repo,
  username: "mjtluxjpsdxmul",
  password: "a00c70afebf84b30517e60b3db70468e8dca4522a5783e7dbaf12bc7fdb75234",
  database: "dej4jdn2h068c1",
  hostname: "ec2-54-247-70-127.eu-west-1.compute.amazonaws.com",
  pool_size: 10,
  port: "5432",
  ssl: true
