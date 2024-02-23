defmodule UrlShortener.ShortenerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.Shortener` context.
  """

  def req_headers() do
    %{
      "host" => "localhost:4000",
      "accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
      "referer" => "http://localhost:4000/stats",
      "connection" => "keep-alive",
      "user-agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0",
      "sec-fetch-dest" => "document",
      "sec-fetch-mode" => "navigate",
      "sec-fetch-site" => "same-origin",
      "sec-fetch-user" => "?1",
      "accept-encoding" => "gzip, deflate, br",
      "accept-language" => "en-US,en;q=0.5",
      "upgrade-insecure-requests" => "1",
      "cookie" => "!!!__SHOULD_NOT_BE_STORED__!!!"
    }
  end

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        creator: csrf_token(),
        path: "5fb63-95br7",
        url: "https://www.youtube.com/watch?v=aCu93MKq7ec"
      })
      |> UrlShortener.Shortener.create_link()

    link
  end

  @doc """
  Generate a visit.
  """
  def visit_fixture(attrs \\ %{}) do
    {:ok, visit} =
      attrs
      |> Enum.into(%{
        ip_address: {100, 37, 113, 54},
        req_headers: req_headers(),
        timestamp: ~U[2024-02-17 06:33:00Z]
      })
      |> UrlShortener.Shortener.log_visit()

    visit
  end

  ## Helpers

  def csrf_token() do
    "pXtCSgjJsbOHILmAvEg5ZpoA"
  end
end
