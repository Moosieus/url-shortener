# Concrete Goals

## Summary
- Aspirationally Scalable
- LiveView Frontend
- Avoid cache (invalidation)
- Use timescaledb
- `bigserial` IDs
- Users as session IDs for now
- Quality of life features (time permitting)
- Other concessions

My primary goal's for this application to be "aspirationally scalable". That's to say it could be reasonably scaled up with a bit more effort invested, rather than necessitating a total rewrite.

Using LiveView for the frontend as opposed to React:
- Faster for prototyping, doesn't require any serialization.
- LiveView's sufficiently sufficient for this application.

Avoid caching data where possible b/c caching begets cache invalidation, and I'd like to be done this weekend.

Keep a log of visits using timescaledb, rather than incrementing a tally:
- Writing to a log is generally non-blocking
- Can store lucrative metadata for each request (headers, IP address, geolocation lookup, etc)
- Improves consistency by removing race conditions
- Scaling this service up would require distribution.
- Logs (read: messages) are the central abstraction for ensuring the consistency of distributed systems, so it's worthwhile building in upfront.
- I'm a huge fan of "I <3 Logs" by Jay Kreps.

Use autoincrementing `bigserial` to punt the maxint problem into a future epoch.
- It's +4 bytes per entry, which at 2 billion log entries would only be 8 gigabytes.
- Problem solved with minimal extra infrastructure costs.

Represent users by their anonymous sessions since the rubric excludes it.
- Were I to eventually implement user accounts, I'd use the [exclusive belongs to](https://hashrocket.com/blog/posts/modeling-polymorphic-associations-in-a-relational-database#exclusive-belongs-to-aka-exclusive-arc-) pattern in order to represent the polymorphic association of shortened links to users.
- Once a user makes an account, all of the existing entries associated with their session ID would be deassociated, and reassociated with their created user ID.
- You could readily represent that constraint in an Ecto changeset as well.

Add some quality of life features, namely:
- Link validation (Check response header with Mint)
- Vanity URLs (very nice to have)
- Real time updates on stats page
- Light and dark mode frontend

These things crossed my mind, but I'm making concessions for the sake of time:
- Ignoring soft deletion of data since this is just a technical for now.
  - I'm partial to a [deleted records table](https://brandur.org/soft-deletion#deleted-records) as it ensures the database can properly ensure integrity.
  - Soft deletes are convenient for restores but annoying for data integrity.
- Most styling, any and all aria or WCAG accessibility concerns.
  - They're really tedious to get right in a prototype.
