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
end
