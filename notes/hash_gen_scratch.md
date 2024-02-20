These are the hash requirements I came up with:
- Must be unique
- not leak any internal details
- Uses Z-Base-32 encoding:
  - Easy to speak and handwrite
  - No confusing characters
  - Only lower case letters
- Good B-tree locality (Start w/ timestamp akin to UUID v7)
- Work alongside vanity urls
- Short enough to be written, communicated, or memorized by people
  - Chunking makes things seem shorter

I think it's neat having them look like a telephone number, 3+3+4.

Z-Base-32 helps reduce handwritten confusion, and uses solely NATO alphabet characters.

```elixir
second = DateTime.utc_now() |> DateTime.to_unix(:second) # 'b178gm8' | div(32**3, 1)
minute = DateTime.utc_now() |> DateTime.to_unix(:second) |> div(60) # '5r7qg' | div(32**5, 60)
hour = DateTime.utc_now() |> DateTime.to_unix(:second) |> div(60) |> div(60) # 'qxp1' | div(32**6, 3600)
day = DateTime.utc_now() |> DateTime.to_unix(:second) |> div(60) |> div(60) |> div(24) # 'ujh' | div(32**7, 86400)
year = DateTime.utc_now() |> DateTime.to_unix(:second) |> div(60) |> div(60) |> div(24) |> div(365) # 'bs' | div(32**8, 31_536_000)
```

Minute seems the best compromise, leaves >500_000 unique IDs for each second.

https://philzimmermann.com/docs/human-oriented-base-32-encoding.txt
