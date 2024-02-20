defmodule UrlShortenerWeb.Live.Create do
  alias UrlShortener.Shortener.Utils
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  def mount(_params, session, socket) do

    socket =
      socket
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
    link_params =
      link_params
      |> Map.update!("path", &gen_path_if_empty/1)
      |> Map.put("creator", socket.assigns.user_id)

    IO.inspect(link_params)

    case Shortener.create_link(link_params) do
      {:ok, link} ->
        socket = put_flash(socket, :info, "link created: #{link.path}")
        IO.inspect(link, label: "yay :D")
        # update this to show that the link's created at the bottom of the card.

        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "no >:(")

        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # The proper way to do this would be to declare a custom Ecto type.
  # Time permitting I'll refactor this into one.
  defp gen_path_if_empty(path) when is_binary(path) do
    case path do
      "" -> Utils.gen_short_id()
      _ -> path
    end
  end
end
