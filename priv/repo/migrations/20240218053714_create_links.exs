defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def up do
    create table(:links) do
      add :path, :text
      add :url, :text
      add :creator, :text

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(:links)
  end
end
