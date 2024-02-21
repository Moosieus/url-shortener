defmodule UrlShortener.Shortener do
  @moduledoc """
  The Shortener context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Shortener.Link
  alias UrlShortener.Shortener.Visit
  alias UrlShortener.DailyVisitCounts

  ## Links

  @doc """
  Returns the list of links for the given user.

  ## Examples

      iex> list_user_links("abcd...")
      [%Link{}, ...]

  """
  def list_user_links(user_id) when is_binary(user_id) do
    query = from(
      l in Link,
      left_join: agg in subquery(visit_total_frag()),
      on: l.id == agg.link_id,
      where: l.creator == ^user_id,
      order_by: [desc: l.inserted_at],
      select: {l.id, l, coalesce(agg.visit_total, 0)}
    )

    Repo.all(query)
  end

  def visit_total_frag() do
    from(
      d in DailyVisitCounts,
      select: %{
        link_id: d.link_id,
        visit_total: type(sum(d.visit_count), :integer)
      },
      group_by: d.link_id
    )
  end

  @spec find_link(binary()) :: %Link{} | nil
  def find_link(path) when is_binary(path) do
    query = from(
      l in Link,
      where: l.path == ^path,
      where: l.active == true
    )

    Repo.one(query)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deactivates a link, removing it from the unique `path` index
  and indicating it should no longer redirect.

  ## Examples

    iex> toggle_link(link)
    {:ok, %Link{}}

    iex> toggle_link(link)
    {:error, %Ecto.Changeset{}}

  """
  def toggle_link(%Link{active: active} = link) do
    link
    |> Link.changeset(%{active: !active})
    |> Repo.update()
  end

  @doc false
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  @doc """
  Logs a visit.

  ## Examples

      iex> log_visit(%{field: value})
      {:ok, %Visit{}}

      iex> log_visit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def log_visit(attrs \\ %{}) do
    %Visit{}
    |> Visit.changeset(attrs)
    |> Repo.insert()
  end
end
