defmodule UrlShortener.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlShortener.Shortener.Utils
  import UrlShortener.Shortener.Utils, only: [validate_url: 2]

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
    |> validate_url(:url)
    |> unique_constraint(:path) # need to use message here!
  end
end
