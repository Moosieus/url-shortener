defmodule UrlShortener.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset
  import UrlShortener.Shortener.Utils

  schema "links" do
    field :path, :string
    field :url, :string
    field :creator, :string
    field :active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:path, :url, :creator])
    |> validate_required([:path, :url, :creator])
    |> validate_length(:url, min: 1, max: 2083)
    # |> validate_length(:path, min: 1, max: 64)
    |> validate_url(:url)
    |> unique_constraint(:path)
  end
end
