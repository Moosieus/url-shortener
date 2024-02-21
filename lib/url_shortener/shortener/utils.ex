defmodule UrlShortener.Shortener.Utils do
  # Cribbed from https://gist.github.com/atomkirk/74b39b5b09c7d0f21763dd55b877f998

  # require at least a scheme, host, and tld
  def validate_url(changeset, field, opts \\ []) do
    import Ecto.Changeset, only: [validate_change: 3]

    validate_change(changeset, field, fn _, value ->
      err_msg =
        case URI.parse(value) do
          %URI{scheme: nil} ->
            "is missing a scheme (e.g. https)"

          %URI{host: nil} ->
            "is missing a host"

          %URI{host: host} ->
            if has_tld?(host), do: nil, else: "is missing a top-level domain (e.g. .com or .org)"
        end

      case err_msg do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end

  defp has_tld?(host) do
    case String.split(host, ".", parts: 2) do
      [_, _] -> true
      [_] -> false
    end
  end

  @nano_id_size 5
  @alphabet_str "ybndrfg8ejkmcpqxot1uwisza345h769"
  @alphabet_map %{
    0 => "y",
    1 => "b",
    2 => "n",
    3 => "d",
    4 => "r",
    5 => "f",
    6 => "g",
    7 => "8",
    8 => "e",
    9 => "j",
    10 => "k",
    11 => "m",
    12 => "c",
    13 => "p",
    14 => "q",
    15 => "x",
    16 => "o",
    17 => "t",
    18 => "1",
    19 => "u",
    20 => "w",
    21 => "i",
    22 => "s",
    23 => "z",
    24 => "a",
    25 => "3",
    26 => "4",
    27 => "5",
    28 => "h",
    29 => "7",
    30 => "6",
    31 => "9"
  }

  def gen_short_id() do
    timestamp =
      DateTime.utc_now()
      |> DateTime.to_unix(:second)
      |> div(60)
      |> encode_timestamp()

    nano_id = Nanoid.generate(@nano_id_size, @alphabet_str)

    timestamp <> "-" <> nano_id
  end

  def encode_timestamp(t) when is_integer(t) do
    do_encode_timestamp(t)
  end

  defp do_encode_timestamp(n, acc \\ [])

  defp do_encode_timestamp(0, acc), do: IO.iodata_to_binary(acc)

  defp do_encode_timestamp(n, acc) do
    q = div(n, 32)
    r = rem(n, 32)

    do_encode_timestamp(q, [@alphabet_map[r] | acc])
  end
end
