defmodule UrlShortenerWeb.Live.MyLinks do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  alias UrlShortenerWeb.Live.MyLinks.ToggleActive

  def mount(_params, session, socket) do
    %{"_csrf_token" => user_id} = session

    socket =
      socket
      |> assign(user_id: user_id)
      |> assign(links: Shortener.list_links(user_id))

    {:ok, socket}
  end

  def handle_info({:toggled_link, %Link{active: true} = link}, socket) do
    socket = put_flash(socket, :info, "Reactivated /#{link.path}")

    {:noreply, socket}
  end

  def handle_info({:toggled_link, %Link{active: false} = link}, socket) do
    socket = put_flash(socket, :info, "Deactivated /#{link.path}")

    {:noreply, socket}
  end
end
