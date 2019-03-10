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
  username: "srizyaiskfqifx",
  password: "125666a9138175941bd2fe8eeca5d399606c28e68d7f9aea9483eafcd72e9ba3",
  database: "dcb1q9nkrg293l",
  hostname: "ec2-54-247-70-127.eu-west-1.compute.amazonaws.com",
  pool_size: 10,
  port: "5432",
  ssl: true
