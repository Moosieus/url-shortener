defmodule UrlShortenerWeb.ExportTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortenerWeb.Export

  describe "GET /export" do
    import UrlShortener.ShortenerFixtures

    # can't test properly due to the CSRF plug not being available during test.
    # this should suffice instead.
    test "Export.send_csv/2 returns a valid csv spreadsheet", %{conn: conn} do
      _link = link_fixture()

      conn = Export.send_csv(conn, csrf_token())

      text = response(conn, 200)

      csv = NimbleCSV.RFC4180.parse_string(text)

      assert match?([[_ | _] | _], csv)
    end
  end
end
