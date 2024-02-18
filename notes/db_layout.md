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
