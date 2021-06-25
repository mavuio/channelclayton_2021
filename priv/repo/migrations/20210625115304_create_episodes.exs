defmodule MyApp.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add(:num, :integer, null: false)
      add(:season_id, references(:seasons))
      add(:title, :string)
      add(:subtitle, :string)
      add(:summary, :text)
      add :link, :string
      add :poster, :string
      timestamps()
    end
    create(unique_index(:episodes, [:num]))

  end
end
