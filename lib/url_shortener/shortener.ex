defmodule UrlShortener.Shortener do
  @moduledoc """
  The Shortener context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Shortener.Link
  alias UrlShortener.Shortener.Visit

  ## Links

  @doc """
  Returns the list of links for the given user.

  ## Examples

      iex> list_links("abcd...")
      [%Link{}, ...]

  """
  def list_links(user_id) when is_binary(user_id) do
    query = from(
      l in Link,
      where: l.creator == ^user_id,
      order_by: [desc: l.inserted_at],
      select: {l.path, l}
    )

    Repo.all(query)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id) when is_integer(id), do: Repo.get!(Link, id)

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

  ## More Link methods. Should only be used for administrative purposes.

  @doc false
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc false
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  ## Visits

  @doc """
  Returns the list of visits.

  ## Examples

      iex> list_visits()
      [%Visit{}, ...]

  """
  def list_visits do
    Repo.all(Visit)
  end

  @doc """
  Gets a single visit.

  Raises `Ecto.NoResultsError` if the Visit does not exist.

  ## Examples

      iex> get_visit!(123)
      %Visit{}

      iex> get_visit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_visit!(id), do: Repo.get!(Visit, id)

  @doc """
  Creates a visit.

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

  @doc """
  Updates a visit.

  ## Examples

      iex> update_visit(visit, %{field: new_value})
      {:ok, %Visit{}}

      iex> update_visit(visit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_visit(%Visit{} = visit, attrs) do
    visit
    |> Visit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a visit.

  ## Examples

      iex> delete_visit(visit)
      {:ok, %Visit{}}

      iex> delete_visit(visit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_visit(%Visit{} = visit) do
    Repo.delete(visit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking visit changes.

  ## Examples

      iex> change_visit(visit)
      %Ecto.Changeset{data: %Visit{}}

  """
  def change_visit(%Visit{} = visit, attrs \\ %{}) do
    Visit.changeset(visit, attrs)
  end
end
