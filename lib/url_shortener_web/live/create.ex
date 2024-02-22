defmodule UrlShortenerWeb.Live.Create do
  @moduledoc """
  LiveView for users to create short links.
  """

  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  embed_templates "create/*"

  def mount(_params, session, socket) do
    socket =
      socket
      |> render_with(&input_form/1)
      |> assign(form: to_form(Shortener.change_link(%Link{})))
      |> assign(user_id: session["_csrf_token"])

    {:ok, socket}
  end

  def handle_event("validate", %{"link" => link_params}, socket) do
    form =
      %Link{}
      |> Shortener.change_link(link_params)
      |> Map.put(:action, :insert)
      |> to_form()

    socket = assign(socket, form: form)

    {:noreply, socket}
  end

  def handle_event("save", %{"link" => link_params}, socket) do
    link_params = Map.put(link_params, "creator", socket.assigns.user_id)

    case Shortener.create_link(link_params) do
      {:ok, link} ->
        socket =
          socket
          |> render_with(&copy/1)
          |> assign(:link, link)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("shorten_another", _params, socket) do
    socket =
      socket
      |> render_with(&input_form/1)
      |> assign(link: nil)
      |> assign(form: to_form(Shortener.change_link(%Link{})))

    {:noreply, socket}
  end
end
