defmodule UrlShortener.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb")

    create table(:visits) do
      add :timestamp, :utc_datetime, null: false, primary_key: true
      add :ip_address, :inet, null: false
      add :req_headers, :map, null: false
      add :link_id, references(:links)
    end

    create index(:visits, [:link_id, :timestamp])

    execute("SELECT create_hypertable('visits', 'timestamp')")
  end

  def down do
    drop table(:visits)

    execute("DROP EXTENSION IF EXISTS timescaledb")
  end
end
