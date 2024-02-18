Tentative database layout:

`links`:
- id:bigint
- short_url:text
- full_url:text
- creator:text
- created_at:utc_timestamp
- updated_at:utc_timestamp
- ~~deleted_at~~ (use deleted records table pattern instead)

`visits` (timescaledb):
- id:bigint
- link_id:fkey
- timestamp:utc_timestamp
- ip_address:inet
- request_headers:jsonb

```sh
phx.gen.context Shortener Link links path:text url:text creator:text
```

I also prefer adding check constraints to tables where possible. They're somewhat redundant given changesets exists, but things happen. Often times more than one application ends up touching a database, or someone refactors without reimplementing some functionality.

An argument could also be made for using explicit timezones with datetimes, but that involves lots of timezone database lookups, so the performance overhead is more significant.


