# Latest version of Erlang-based Elixir installation: https://hub.docker.com/_/elixir/
FROM elixir

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

# Run the application itself
CMD ./scripts/docker.sh

EXPOSE 4000