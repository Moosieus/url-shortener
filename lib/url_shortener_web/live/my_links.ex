defmodule UrlShortenerWeb.Live.MyLinks do
  alias UrlShortener.Shortener
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener.Link
  #alias UrlShortener.Shortener

  def mount(_params, session, socket) do
    %{"_csrf_token" => user_id} = session

    socket =
      socket
      |> assign(user_id: user_id)
      |> assign(links: Shortener.list_links(user_id))

    {:ok, socket}
  end
end
