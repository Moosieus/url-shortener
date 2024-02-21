defmodule UrlShortener.DailyVisitCounts do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_visit_counts" do
    field :day, :date
    field :link_id, :id
    field :visit_count, :integer
  end

  @doc false
  def changeset(daily_visit_counts, attrs) do
    daily_visit_counts
    |> cast(attrs, [:views])
    |> validate_required([:views])
  end
end
