defmodule UrlShortenerWeb.Live.MyLinks do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  alias UrlShortenerWeb.Live.MyLinks.ToggleActive

  def mount(_params, session, socket) do
    %{"_csrf_token" => user_id} = session

    if connected?(socket) do
      Phoenix.PubSub.subscribe(UrlShortener.PubSub, "user_visits:#{user_id}")
    end

    socket =
      socket
      |> assign(user_id: user_id)
      |> assign(links: Shortener.list_user_links(user_id))

    {:ok, socket}
  end

  def handle_info({:visit, _link_id, link_path}, socket) do
    links = socket.assigns.links

    links =
      case List.keyfind(links, link_path, 0) do
        {path, link, visits} ->
          List.keyreplace(links, link_path, 0, {path, link, visits+1})
        nil ->
          links
      end

    socket = assign(socket, links: links)

    {:noreply, socket}
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
