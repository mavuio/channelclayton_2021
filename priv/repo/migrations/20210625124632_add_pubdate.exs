defmodule MyApp.Repo.Migrations.AddPubdate do
  use Ecto.Migration

  def change do
    alter table(:episodes) do
      add(:pubdate, :naive_datetime)
    end

  end
end
