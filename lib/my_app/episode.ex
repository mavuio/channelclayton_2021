defmodule MyApp.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episodes" do
    field(:num, :integer)
    field(:season_id, :integer)
    field(:title, :string)
    field(:subtitle, :string)
    field(:summary, :string)
    field(:duration, :string)
    field(:link, :string)
    field(:image, :string)
    timestamps()
  end

  use Accessible

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [
      :num,
      :season_id,
      :title,
      :subtitle,
      :summary,
      :duration,
      :link,
      :image
    ])
    |> validate_format(:duration, ~r/\d\d:\d\d:\d\d$/, message: "must be in format HH:MM:SS")

    # |> validate_required([
    #   :name
    # ])
  end
end

# "duration": "00:10:27",
# "link": "https://channel-clayton.uni-ak.ac.at/index.php/das-telefongesprach/",
# "poster": "/podcast/img/logo-itunes.jpg",
# "publicationDate": "2020-06-19T12:02:00+02:00",

# "subtitle": "Erforschung des verschwindenden Alltagsmediums Festnetztelefon in Österreich 1950–2010 von Barbara Kedl-Hecher",
# "title": "Episode 02 - Das Telefongespräch | Barbara Kedl-Hecher",
# "version": 5
