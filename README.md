# Url Shortener Demo

## Setup
1. Install Postgres *with* TimescaleDB

You have 3 options for setting up TimescaleDB:
  1. **Uninstall any versions of Postgres you may have** and host Timescaledb from a pre-built Docker container.
  2. Compile TimescaleDB from source and install it on your local Postgres database.
  3. Install TimescaleDB from PPA and install it on your local Postgres database.

**[See the warning here](https://docs.timescale.com/self-hosted/latest/install/installation-docker/)**, Timescale is very adamant about this!

2. Start Phoenix:
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
