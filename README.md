# QuickcourtBackend

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## To run in the Docker:
1. Ensure yourself that you are running Postgres on localhost with the user quickcourt with password quickcourt on port 5432, if this is different edit the config dev.exs file
2. Build the docker image using following command: `docker build -t quickcourt_backend . --no-cache`
3. Run the server usin the following command: `docker run -p 4000:4000 quickcourt_backend:latest`
