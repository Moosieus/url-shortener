defmodule UrlShortener.Repo.Migrations.CreateVisitCounts do
  use Ecto.Migration
  @disable_ddl_transaction true

  def up() do
    execute("""
      CREATE MATERIALIZED VIEW daily_visit_counts
      WITH (timescaledb.continuous, timescaledb.materialized_only=false) AS
      SELECT time_bucket(INTERVAL '1 day', "timestamp") AS day, link_id, COUNT(*) AS visit_count
      FROM visits
      GROUP BY link_id, time_bucket(INTERVAL '1 day', "timestamp")
      WITH NO DATA;
    """)
  end

  def down() do
    execute("DROP MATERIALIZED VIEW IF EXISTS daily_visit_counts")
  end
end
