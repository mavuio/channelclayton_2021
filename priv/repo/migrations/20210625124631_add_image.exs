defmodule MyApp.Repo.Migrations.AddImage do
  use Ecto.Migration

  def change do
    alter table(:episodes) do
      add(:image, :string)
    end

  end
end
