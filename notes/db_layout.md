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


```sh
mix phx.gen.context Shortener Visit visits link_id:references:link timestamp:utc_datetime ip_address:text request_headers:map
# this one needed lots of work...
```

Also worth noting I specify not null wherever possible, as a matter of ensuring invalid data can't leak into the database.

Foreign keys ask hard questions:
- Link paths need a unique constraint
- links we have on the links table are in effect "live links". If a link is deleted it shouldn't be there, full stop.
- Visits still need to identify what they were visiting
- Visits' foreign key to links should be nullable to reflect that links can be deleted.
- Visits will "freeze" their link as jsonb when saving.
- We can accurately see what visits were redirected to at the time executed.

Note to self: pick up here.
