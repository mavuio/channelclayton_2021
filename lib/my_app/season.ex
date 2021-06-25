defmodule MyApp.Season do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seasons" do
    field :num, :integer
    field :title, :string
    field :subtitle, :string
    field :link, :string
    field :poster, :string
    field :summary, :string
    timestamps()
  end

  use Accessible

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [
      :title,
      :num,
      :subtitle,
      :link,
      :poster,
      :summary
    ])

    # |> validate_required([
    #   :name
    # ])
  end
end

#     "link": "https://channel-clayton.uni-ak.ac.at/",
#     "poster": "/podcast/img/logo-itunes.jpg",
#     "subtitle": "Wissenschaftliche Abschlussarbeiten des Instituts für Kunstwissenschaften, Kunstpädagogik und Kunstvermittlung",
#     "summary": "Channel Clayton ist auf dem Angewandte Festival 2020 als Podcast vertreten",
#     "title": "Channel Clayton—Mithören"
