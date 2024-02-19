defmodule UrlShortener.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def up do
    create table(:visits) do
      add :timestamp, :utc_datetime, null: false
      add :ip_address, :inet, null: false
      add :request_headers, :map, null: false
      add :link_id, references(:links)
    end

    create index(:visits, [:link_id])
  end

  def down do
    drop table(:visits)
  end
end
