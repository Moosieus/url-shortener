defmodule UrlShortener.Shortener.Link do
  @moduledoc """
  Represents a redirect link created by a user.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlShortener.Shortener.Link.Utils

  schema "links" do
    field :path, :string, autogenerate: {Utils, :gen_short_id, []}
    field :url, :string
    field :creator, :string
    field :active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:path, :url, :creator, :active])
    |> validate_required([:url, :creator, :active])
    |> validate_length(:url, min: 1, max: 2083)
    |> validate_length(:path, min: 1, max: 64)
    |> Utils.validate_url(:url)
    # need to use message here!
    |> unique_constraint(:path, name: "links_path_uniq")
  end
end
