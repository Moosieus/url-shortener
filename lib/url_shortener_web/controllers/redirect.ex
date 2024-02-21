defmodule UrlShortenerWeb.Redirect do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.Link

  def index(conn, %{"path" => path}) do
    case Shortener.find_link(path) do
      %Link{} = link ->
        redirect_and_log(conn, link)

      nil ->
        not_found(conn)
    end
  end

  defp redirect_and_log(%Plug.Conn{} = conn, %Link{} = link) do
    conn =
      conn
      |> redirect(external: link.url)
      |> halt()

    Shortener.log_visit(%{
      timestamp: DateTime.utc_now(:millisecond),
      req_headers: Enum.into(conn.req_headers, %{}),
      link_id: link.id,
      ip_address: conn.remote_ip
    })

    conn
  end

  defp not_found(conn) do
    conn
    |> put_status(404)
    |> put_view(html: UrlShortenerWeb.ErrorHTML)
    |> render("404.html", %{message: "This link does not exist or has been deactivated."})
    |> halt()
  end
end
