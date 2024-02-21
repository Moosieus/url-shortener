defmodule UrlShortener.ShortenerTest do
  use UrlShortener.DataCase

  alias UrlShortener.Shortener

  describe "links" do
    alias UrlShortener.Shortener.Link

    import UrlShortener.ShortenerFixtures

    @invalid_attrs %{path: nil, url: nil, creator: nil}

    test "list_user_links/0 returns all links" do
      link = link_fixture()
      assert Shortener.list_user_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Shortener.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{path: "some path", url: "some url", creator: "some creator"}

      assert {:ok, %Link{} = link} = Shortener.create_link(valid_attrs)
      assert link.path == "some path"
      assert link.url == "some url"
      assert link.creator == "some creator"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shortener.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        path: "some updated path",
        url: "some updated url",
        creator: "some updated creator"
      }

      assert {:ok, %Link{} = link} = Shortener.update_link(link, update_attrs)
      assert link.path == "some updated path"
      assert link.url == "some updated url"
      assert link.creator == "some updated creator"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Shortener.update_link(link, @invalid_attrs)
      assert link == Shortener.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Shortener.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Shortener.get_link!(link.id) end
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

    test "list_visits/0 returns all visits" do
      visit = visit_fixture()
      assert Shortener.list_visits() == [visit]
    end

    test "get_visit!/1 returns the visit with given id" do
      visit = visit_fixture()
      assert Shortener.get_visit!(visit.id) == visit
    end

    test "log_visit/1 with valid data creates a visit" do
      valid_attrs = %{
        timestamp: ~U[2024-02-17 06:33:00Z],
        ip_address: "some ip_address",
        req_headers: %{}
      }

      assert {:ok, %Visit{} = visit} = Shortener.log_visit(valid_attrs)
      assert visit.timestamp == ~U[2024-02-17 06:33:00Z]
      assert visit.ip_address == "some ip_address"
      assert visit.req_headers == %{}
    end

    test "log_visit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shortener.log_visit(@invalid_attrs)
    end

    test "update_visit/2 with valid data updates the visit" do
      visit = visit_fixture()

      update_attrs = %{
        timestamp: ~U[2024-02-18 06:33:00Z],
        ip_address: "some updated ip_address",
        req_headers: %{}
      }

      assert {:ok, %Visit{} = visit} = Shortener.update_visit(visit, update_attrs)
      assert visit.timestamp == ~U[2024-02-18 06:33:00Z]
      assert visit.ip_address == "some updated ip_address"
      assert visit.req_headers == %{}
    end

    test "update_visit/2 with invalid data returns error changeset" do
      visit = visit_fixture()
      assert {:error, %Ecto.Changeset{}} = Shortener.update_visit(visit, @invalid_attrs)
      assert visit == Shortener.get_visit!(visit.id)
    end

    test "delete_visit/1 deletes the visit" do
      visit = visit_fixture()
      assert {:ok, %Visit{}} = Shortener.delete_visit(visit)
      assert_raise Ecto.NoResultsError, fn -> Shortener.get_visit!(visit.id) end
    end

    test "change_visit/1 returns a visit changeset" do
      visit = visit_fixture()
      assert %Ecto.Changeset{} = Shortener.change_visit(visit)
    end
  end
end
