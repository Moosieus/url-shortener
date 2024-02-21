# Disclaimer
I'm writing these notes as I'm exploring different angles of creating this application. Not all of them are necessarily good, if at all sane. 

# A URL Shortener to call my own

- Phoenix, obviously.
- Visit submitted links with Mint, validate they return a 200-399 response.
- Go off Refactoring UI for the UI (read: No more than is necessary).
- Support dark mode.
- LiveView frontend b/c it's quick and easy for prototyping.
- Track users with cookies for now.
- Consider security considerations

Submit link -> Mint visits link ->
```elixir
case status in 200..399 do
  true ->
    {:success, "turn the UI green or something"}
  false ->
    {:warning, "This URL returned an invalid status: 404 Page Not Found. Would you like to generate this link anyway? Yes/No"}
end
```

## What would authentication look like?
- Anonymous users would simply be associated by a session cookie.
- When a user creates an account for the first time, their links would move association to their user.
- They must login to view their stats, but their stats

**That begs a question:** How do you dynamically associate links to either a user or session cookie?

Natural consequence of this is a polymorphic association, which Postgres doesn't natively support.

[This SO answer](https://dba.stackexchange.com/questions/289214/single-foreign-key-for-referencing-one-of-multiple-tables) links to a [very good article](https://hashrocket.com/blog/posts/modeling-polymorphic-associations-in-a-relational-database).

In this instance, I'd use an "Exclusive Belongs To" check:
- Can ensure foreign keys are always valid
- Doesn't require complex joins
- Business logic is strictly enforced (until it isn't)
- We can do this b/c Ecto is cool

This approach preferable to just making every session cookie a potential user on the users table, as the amount of session cookies will vastly out-number the amount of user accounts.

## Visiting links to ensure validity
- This perhaps invites security risks, and it's arguably safter not to do it.
- In the real world, a company like bit.ly would need to heavily isolate testing links.
- Using Mint, I can just read the status of the HTTP request, and absolutely no more.

## Incrementing the visit count
- I want the visit count to update in real-time. After all, that's the whole point of Phoenix, and STORD deals entirely in real-time.
- One `UPDATE` query per visit gets expensive fast. An in-memory, eventually-persisted solution would be better.
- In a larger system operating across distributed nodes, we'd need a consistent (*idempotent?*) way to count visits.
- ~~For the purpose of this application, I'm going to keep it to one logical node~~.
- Instead of doing that, I'd like to do this in a way that could plausably be scaled.
- Each visit should be a log, likely a message on a Phoenix PubSub channel.
- Once you message pass the occurence of a visit, you're unblocked.

**Let's maybe get back down to Earth and finish this thing this weekend.**
- Use `&Plug.Conn.send_resp/3` to send the response first, and do our dirty work afterwards.
- Send out the visit log to update viewers and handle persistence.
- Keep the message under 64 bytes.
  - Use `bigserial` for the link table, effectively punting that max int problem into a future epoch :V
- Persist to an in-memory store
  - Keep this relatively simple but definitely **idempotent**.

## Vanity URLS?
- Allow them, for everyone! Let them eat cake! Hapiness for everybody, free, and no one will go away unsatisfied!
- Could argue there's a potential for abuse.
- Abusers are already more sophisticated. They register domains and can use their own link shorteners, should they desire.
- Need to generate a short, unique hash for each link. Short and unique don't exactly go together.
- Figure out a nice hash generating algorithm for this.
- Definitely keep a unique constraint on this.

## Security considerations
- Limit input url sizes
- ensure all shortened paths are unique
- Only check the respone status of any sites, don't parse anything else

# Note about visit timestamps
- Don't use a default for insertion in either ecto or the database. It's more correct that the timestamp is recorded close to the moment of request.
- If logging visits ended up having to go through a longer pipeline or Kafka, the timestamp could be considerably off.
