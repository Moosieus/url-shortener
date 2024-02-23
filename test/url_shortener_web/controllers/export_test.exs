defmodule UrlShortenerWeb.ExportTest do
  use UrlShortenerWeb.ConnCase

  describe "GET /export/:user_id" do
    # setup [:seed]

    test "returns a valid csv spreadsheet", %{conn: conn} do
      conn = get(conn, ~p"/export/:user_id")

      bin_resp = text_response(conn, 200)

      csv = NimbleCSV.RFC4180.parse_string(bin_resp)

      assert match?([[_ | _] | _], csv)
    end
  end

  # defp seed(context) do
  #   IO.inspect(context, label: "context")
  # end
end
