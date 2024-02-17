defmodule UrlShortenerWeb.PageController do
  use UrlShortenerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: {UrlShortenerWeb.Layouts, :app})
  end
end
