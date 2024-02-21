defmodule UrlShortenerWeb.Live.MyLinks.ToggleActive do
  @moduledoc false
  use Phoenix.LiveComponent

  # this needs to be a live component so it can reference state.
  # otherwise it's stateless.

  import UrlShortenerWeb.CoreComponents, only: [icon: 1]

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  def render(%{link: %Link{active: true}} = assigns) do
    ~H"""
    <button phx-click="toggle_active" phx-target={@myself}>
      <.icon name="hero-check" class="cursor-pointer text-green-800 dark:text-green-300" />
    </button>
    """
  end

  def render(%{link: %Link{active: false}} = assigns) do
    ~H"""
    <button phx-click="toggle_active" phx-target={@myself}>
      <.icon name="hero-archive-box" class="cursor-pointer text-red-800 dark:text-red-300" />
    </button>
    """
  end

  def handle_event("toggle_active", _params, socket) do
    %Phoenix.LiveView.Socket{
      assigns: %{
        link: %Link{} = link,
        on_toggle: on_toggle
      }
    } = socket

    case Shortener.toggle_link(link) do
      {:ok, %Link{} = link} ->
        on_toggle.(link)

        {:noreply, assign(socket, link: link)}

      {:error, %Ecto.Changeset{} = _changeset} ->
        socket = put_flash(socket, :error, "placeholder, it didn't work!")
        {:noreply, socket}
    end
  end
end
