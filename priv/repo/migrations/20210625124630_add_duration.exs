defmodule MyApp.Repo.Migrations.AddDuration do
  use Ecto.Migration

  def change do
    alter table(:episodes) do
      add(:duration, :string)
    end

  end
end
