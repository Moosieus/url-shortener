defmodule UrlShortener.ShortenerTest do
  use UrlShortener.DataCase

  alias UrlShortener.Shortener

  describe "links" do
    alias UrlShortener.Shortener.Link

    import UrlShortener.ShortenerFixtures

    @invalid_attrs %{path: nil, url: nil, creator: nil}

    test "list_user_links/1 returns all links for user" do
      %Link{} = link_fixture = link_fixture()

      [{_id, link, _visits}] = Shortener.list_user_links(csrf_token())

      assert link == link_fixture
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{
        path: "shazbot",
        url: "https://www.tribes3rivals.com/",
        creator: csrf_token()
      }

      assert {:ok, %Link{} = link} = Shortener.create_link(valid_attrs)
      assert link.path == "shazbot"
      assert link.url == "https://www.tribes3rivals.com/"
      assert link.creator == csrf_token()
      assert link.active == true
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shortener.create_link(@invalid_attrs)
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Shortener.change_link(link)
    end
  end

  describe "visits" do
    alias UrlShortener.Shortener.Visit

    import UrlShortener.ShortenerFixtures

    @invalid_attrs %{timestamp: nil, ip_address: nil, req_headers: nil}

    test "log_visit/1 with valid data creates a visit" do
      link = link_fixture()

      valid_attrs = %{
        timestamp: ~U[2024-02-17 06:33:00Z],
        ip_address: {127, 0, 0, 1},
        req_headers: req_headers(),
        link_id: link.id
      }

      assert {:ok, %Visit{} = visit} = Shortener.log_visit(valid_attrs)
      assert visit.timestamp == ~U[2024-02-17 06:33:00Z]
      assert visit.ip_address == %Postgrex.INET{address: {127, 0, 0, 1}, netmask: 32}
      assert 0 < Enum.count(visit.req_headers)
      assert visit.link_id == link.id
    end

    test "log_visit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shortener.log_visit(@invalid_attrs)
    end

    test "log_visit/1 does not save sensitive headers" do
      link = link_fixture()

      valid_attrs = %{
        timestamp: ~U[2024-02-17 06:33:00Z],
        ip_address: {127, 0, 0, 1},
        req_headers: req_headers(),
        link_id: link.id
      }

      assert {:ok, %Visit{} = visit} = Shortener.log_visit(valid_attrs)

      for header <- Visit.sensitive_headers() do
        assert Map.has_key?(visit.req_headers, header) === false
      end
    end
  end
end
