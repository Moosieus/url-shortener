defmodule UrlShortener.Shortener.Validators do
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
end
