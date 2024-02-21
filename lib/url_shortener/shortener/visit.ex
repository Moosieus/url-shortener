defmodule UrlShortener.Shortener.Visit do
  @moduledoc """
  Records a visit to an existing shortened link. That's to say,
  a request to a non-existent shortened link will 404, and not be recorded here.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "visits" do
    field :timestamp, :utc_datetime
    field :ip_address, EctoNetwork.INET
    field :req_headers, :map

    belongs_to :link, Link
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:timestamp, :ip_address, :req_headers, :link_id])
    |> validate_required([:timestamp, :ip_address, :req_headers, :link_id])
  end
end
