defmodule UrlShortenerWeb.Redirect do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  def index(conn, %{"path" => path}) do
    case Shortener.find_link(path) do
      %Link{} = link ->
        redirect(conn, external: link.url)

      nil ->
        conn
        |> put_status(404)
        |> render(UrlShortenerWeb.ErrorHTML, "404.html")
        |> halt()
    end
  end
end
