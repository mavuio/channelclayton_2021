defmodule MyApp.Seasons do
  @moduledoc false
  alias MyApp.Season, warn: false

  alias MyApp.Repo

  require Ecto.Query

  def get_query(_params, _context) do
    Season
    |> Ecto.Query.from()
  end

  def get_season(id) when is_integer(id) do
    Repo.get_by(Season, id: id)
  end

  def get_season(%Season{} = season), do: season

  def get_season(_), do: nil

  def get_for_dropdown() do
    get_query(nil, nil)
    |> Repo.all()
    |> Enum.map(fn s -> {"#{s.num} - #{s.title}", s.id} end)
  end

  def get_season_config(season_or_id)
      when is_integer(season_or_id) or is_struct(season_or_id) do
    season = get_season(season_or_id)

    %{
      #     audio: [{
      #         duration: "00:10:27",
      #         mimeType: "audio/mpeg",
      #         size: 10046061,
      #         title: "MP3 Audio (mp3)",
      #         url: "/podcast/seasons/season02.mp3"
      #     }, {
      #         duration: "00:10:27",
      #         mimeType: "audio/mp4",
      #         size: 10140464,
      #         title: "MPEG-4 AAC Audio (m4a)",
      #         url: "/podcast/seasons/season02.m4a"
      #     }, {
      #         duration: "00:10:27",
      #         mimeType: "audio/ogg",
      #         size: 6731638,
      #         title: "Ogg Vorbis Audio (oga)",
      #         url: "/podcast/seasons/season02.ogg"
      #     }],
      #     duration: "00:10:27",
      #     show: {
      #         link: "https://channel-clayton.uni-ak.ac.at/",
      #         poster: "/podcast/img/logo-itunes.jpg",
      #         subtitle: "Wissenschaftliche Abschlussarbeiten des Instituts für Kunstwissenschaften, Kunstpädagogik und Kunstvermittlung",
      #         summary: "Channel Clayton ist auf dem Angewandte Festival 2020 als Podcast vertreten",
      #         title: "Channel Clayton—Mithören"
      #     },
      #     subtitle: "Erforschung des verschwindenden Alltagsmediums Festnetztelefon in Österreich 1950–2010 von Barbara Kedl-Hecher",
      #     title: "Season 02 - Das Telefongespräch | Barbara Kedl-Hecher",
      link: "https://channel-clayton.uni-ak.ac.at/index.php/season_id/#{season.id}",
      poster: "/podcast/img/logo-itunes.jpg",
      publicationDate: "2020-06-19T12:02:00+02:00",
      version: 5
    }
  end
end
