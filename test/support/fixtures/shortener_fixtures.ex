defmodule UrlShortener.ShortenerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.Shortener` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        creator: "some creator",
        path: "some path",
        url: "some url"
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
        ip_address: "some ip_address",
        req_headers: %{},
        timestamp: ~U[2024-02-17 06:33:00Z]
      })
      |> UrlShortener.Shortener.log_visit()

    visit
  end
end
