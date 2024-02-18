defmodule UrlShortener.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :path, :string
    field :url, :string
    field :creator, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:path, :url, :creator])
    |> validate_required([:path, :url, :creator])
    |> validate_length(:url, min: 1, max: 2083)
    |> unique_constraint(:path)
  end
end
