# Final choices and concessions

- LiveView frontend:
  - Reasonably easy and fast.
  - Makes form validation easy.

- Qualify of life features:
  - Light and dark mode. Wrote hll-live-browser, copied over.
  - Modicum of styling, I like stuff to be presentable.
  - Vanity urls seem desirable.
  - Being able to deactivate links seems ideal.

- Links table:
  - Added constraints to ensure data stays valid.
  - I've often seen apps share databases. Codeifying constraints is prudent here.
  - Partially unique index allows deactivated links to be "unparked".

- Unique ID generation:
  - Prefixed with a timestamp for good cache locality.
  - Timestamp increments each minute.
  - ~500k unique IDs available per second.
  - Chunked 5 to 5 for memorization.
  - 5:5/10 was the best allotment for uniqueness.
  - Could grow in the future if needed.
  - Z-Base-32 encoding for easy vocalization and transcription.

- Timescaledb for visit log:
  - Visits are inherently time series.
  - Getting the total visit count is the least interesting thing we can do.
  - Data is the key.
  - Use a materialzed view to query data summaries (efficient).
  - I've never used Timescaledb before this, but it seemed fit for purpose.

- Allowed links to be archived but not removed:
  - Ensures data integrity remains and isn't lost.
  - View data always maps to what it was.
  - Allowed me to turn this around faster.

- Code organization:
  - Followed idiomatic Phoenix conventions as close as possible.
  - Kept code declarative, intentional, and in the correct contexts.

# Concessions for time:

- Didn't check urls with Mint:
  - Sometimes links may not be queryable anyway (ex: steam://connect/<ip_address> links).
  - I've done lots of client libraries already (see elixir-a2s and kevo_ex).

- The creation UI is lacking:
  - Central card should expand and have a "copy me" functionality.
  - UI should cycle back to a create-another state.

- Not all tests passing:
  - Will get around to it time permitting.

- Theme toggle breaks on navigation:
  - Hardstuck on this but it'll pass for demonstration.
