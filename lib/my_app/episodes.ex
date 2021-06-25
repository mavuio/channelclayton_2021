defmodule MyApp.Episodes do
  @moduledoc false
  alias MyApp.Episode, warn: false

  alias MyApp.Repo

  require Ecto.Query

  def get_query(_params, _context) do
    Episode
    |> Ecto.Query.from()
  end

  def get_episode(id) when is_integer(id) do
    Repo.get_by(Episode, id: id)
  end

  def get_episode(%Episode{} = episode), do: episode

  def get_episode(_), do: nil

  def get_episodes() do
    get_query(nil, nil)
    |> Repo.all()
  end

  def get_episode_config(episode_or_id)
      when is_integer(episode_or_id) or is_struct(episode_or_id) do
    episode = get_episode(episode_or_id)

    %{
      #     audio: [{
      #         duration: "00:10:27",
      #         mimeType: "audio/mpeg",
      #         size: 10046061,
      #         title: "MP3 Audio (mp3)",
      #         url: "/podcast/episodes/episode02.mp3"
      #     }, {
      #         duration: "00:10:27",
      #         mimeType: "audio/mp4",
      #         size: 10140464,
      #         title: "MPEG-4 AAC Audio (m4a)",
      #         url: "/podcast/episodes/episode02.m4a"
      #     }, {
      #         duration: "00:10:27",
      #         mimeType: "audio/ogg",
      #         size: 6731638,
      #         title: "Ogg Vorbis Audio (oga)",
      #         url: "/podcast/episodes/episode02.ogg"
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
      #     title: "Episode 02 - Das Telefongespräch | Barbara Kedl-Hecher",
      link: "https://channel-clayton.uni-ak.ac.at/index.php/episode_id/#{episode.id}",
      poster: "/podcast/img/logo-itunes.jpg",
      publicationDate: "2020-06-19T12:02:00+02:00",
      version: 5
    }
  end

  def get_latest_change_date() do
    Repo.aggregate(Episode, :max, :updated_at)
  end
end
