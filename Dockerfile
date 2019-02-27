# Latest version of Erlang-based Elixir installation: https://hub.docker.com/_/elixir/
FROM elixir

# Install dependencies for HTML/PDF conversion and generation
RUN apt-get update && apt-get install -y wkhtmltopdf pdftk xvfb libfontconfig

# Create and set home directory
WORKDIR /opt/quickcourt_backend

# Configure required environment
ENV MIX_ENV dev

# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all application files
COPY . .

# Install all deps
RUN mix deps.get --force

# Compile all dependencies
RUN mix deps.compile

# Compile the entire project
RUN mix compile

# Drop the database so it is empty
RUN mix ecto.drop

# Setup the database with demo data
RUN mix ecto.setup

# Run the application itself
CMD iex -S mix phx.server

EXPOSE 4000