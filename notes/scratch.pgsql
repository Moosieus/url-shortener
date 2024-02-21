/*
  Took me a moment to find the right incantation:
  + `timescaledb.materialized_only=false`
  + `WITH NO DATA`
*/

CREATE MATERIALIZED VIEW daily_visit_counts
WITH (timescaledb.continuous, timescaledb.materialized_only=false) AS
SELECT
  time_bucket(INTERVAL '1 day', "timestamp") AS day, link_id, COUNT(*) AS visit_count
FROM
  visits
GROUP BY link_id, time_bucket(INTERVAL '1 day', "timestamp");

SELECT link_id, SUM("visit_count")
FROM daily_visit_counts
GROUP BY link_id;

GRANT ALL ON daily_visit_counts TO url_shortener;

SELECT a.view_name,
       p.policy_name,
       p.job_id,
       p.schedule_interval,
       p.max_interval_per_job,
       p.start_offset,
       p.end_offset
FROM timescaledb_information.continuous_aggregates a
JOIN timescaledb_information.policy_stats p ON a.daily_visit_counts = p.hypertable
WHERE a.view_name = 'daily_visit_counts';

/*
start_offset = 6 seconds
end_offset = NULL (always latest)
schedule_interval = 3 seconds
*/
SELECT add_continuous_aggregate_policy(
  'daily_visit_counts',
  start_offset => INTERVAL '6 seconds',
  end_offset => NULL,
  schedule_interval => INTERVAL '3 seconds'
);

SELECT remove_continuous_aggregate_policy('daily_visit_counts');

SELECT timescaledb_experimental.show_policies('daily_visit_counts');

/* WITH NO DATA is the key! */

CREATE MATERIALIZED VIEW daily_visit_counts
WITH (timescaledb.continuous, timescaledb.materialized_only=false) AS
SELECT
  time_bucket(INTERVAL '1 day', "timestamp") AS day, link_id, COUNT(*) AS visit_count
FROM
  visits
GROUP BY link_id, time_bucket(INTERVAL '1 day', "timestamp")
WITH NO DATA;

/* try this */
SELECT id from _timescaledb_catalog.hypertable
	WHERE table_name=(
    	SELECT materialization_hypertable_name
        	FROM timescaledb_information.continuous_aggregates
        	WHERE view_name='daily_visit_counts'
	);