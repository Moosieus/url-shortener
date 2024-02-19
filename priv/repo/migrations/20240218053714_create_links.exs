defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def up do
    create table(:links) do
      add :path, :text, [size: 64, null: false]
      add :url, :string, [size: 2048, null: false]
      add :creator, :text, null: false
      add :active, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:links, [:path], name: "links_path_uniq")

    create constraint(:links, :path_not_blank, check: "path != ''")
    create constraint(:links, :url_not_blank, check: "url != ''")
    create constraint(:links, :creator_not_blank, check: "creator != ''")
  end

  def down do
    drop table(:links)
  end
end
