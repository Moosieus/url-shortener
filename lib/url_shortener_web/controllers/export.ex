defmodule UrlShortenerWeb.Export do
  @moduledoc """
  Dedicated endpoint module for exporting a user's link stats to a spreadsheet (csv).
  """
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener.Link
  alias UrlShortener.Shortener

  @csv_headers [["path", "source_link", "visits", "date_created", "active"]]

  def index(conn, %{"user_id" => user_id}) do
    csv =
      link_data(user_id)
      |> NimbleCSV.RFC4180.dump_to_iodata()
      |> IO.iodata_to_binary()

    now = Date.utc_today() |> Date.to_string()

    send_download(conn, {:binary, csv}, filename: "visits_#{now}.csv")
  end

  defp link_data(user_id) do
    Shortener.list_user_links(user_id)
    |> Stream.map(&map_to_list/1)
    |> then(&Stream.concat(@csv_headers, &1))
  end

  defp map_to_list({_, %Link{} = link, visits}) do
    [link.path, link.url, visits, DateTime.to_iso8601(link.inserted_at), link.active]
  end
end
