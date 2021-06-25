defmodule MyApp.Repo.Migrations.CreateSeasons do
  use Ecto.Migration

  def change do
    create table(:seasons) do
      add :num, :integer, null: false
      add :title, :string
      add :subtitle, :string
      add :summary, :text
      add :link, :string
      add :poster, :string
      timestamps()
    end
    create(unique_index(:seasons, [:num]))
  end


end
