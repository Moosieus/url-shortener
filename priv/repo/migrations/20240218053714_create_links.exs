defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def up do
    create table(:links) do
      add :path, :text, [null: false, check: "path != ''"]
      add :url, :text, null: false
      add :creator, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create constraint(:links, :path_not_blank, check: "path != ''")
    create constraint(:links, :url_not_blank, check: "url != ''")
    create constraint(:links, :creator_not_blank, check: "creator != ''")
  end

  def down do
    drop table(:links)
  end
end
