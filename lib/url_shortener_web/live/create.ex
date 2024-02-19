defmodule UrlShortenerWeb.Live.Create do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  def mount(_params, _session, socket) do
    socket = assign(socket, form: to_form(Shortener.change_link(%Link{})))

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
    case Shortener.create_link(link_params) do
      {:ok, _link} ->
        socket = put_flash(socket, :info, "link created")
        # update this to show that the link's created at the bottom of the card.

        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
