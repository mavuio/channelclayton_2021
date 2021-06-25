defmodule MyApp.Episodes do
  @moduledoc false
  alias MyApp.Episode, warn: false

  alias MyApp.Repo

  require Ecto.Query

  def get_query(_params, _context) do
    Episode
    |> Ecto.Query.order_by(desc: :num)
    |> Ecto.Query.from()
  end

  def get_episode(id) when is_integer(id) do
    Repo.get_by(Episode, id: id)
  end

  def get_episode(%Episode{} = episode), do: episode

  def get_episode(_), do: nil

  @spec get_episode_by_num(nil | binary | number | Decimal.t()) :: any
  def get_episode_by_num(num) do
    Repo.get_by(Episode, num: MavuUtils.to_int(num))
  end

  def get_episodes() do
    get_query(nil, nil)
    |> Repo.all()
  end

  def get_episode_config(episode_or_num)
      when is_integer(episode_or_num) or is_struct(episode_or_num) do
    episode = get_episode_by_num(episode_or_num)

    %{
      audio: [
        %{
          duration: episode.duration,
          mimeType: "audio/mpeg",
          size: 20_000_000,
          title: "MP3 Audio (mp3)",
          url: "/podcast/episodes/episode#{episode.num}.mp3"
        }
      ],
      show: %{
        link: "https://channel-clayton.uni-ak.ac.at/",
        poster: "/podcast/img/logo-itunes.jpg",
        subtitle: MyAppWeb.FrontendHelpers.snip("de", "/feed/general.subtitle_textline"),
        summary:
          MyAppWeb.FrontendHelpers.snip("de", "/feed/general.description_plaintext", nil,
            format_as: "plaintext"
          ),
        title: MyAppWeb.FrontendHelpers.snip("de", "/feed/general.title_textline")
      },
      title: "Episode #{episode.num} - #{episode.title}",
      duration: episode.duration,
      subtitle: "n/a",
      link: episode.link,
      poster: "/podcast/img/logo-itunes.jpg",
      publicationDate: episode.pubdate |> MyAppWeb.FrontendHelpers.json_date(),
      version: 5
    }
  end

  def get_latest_change_date() do
    Repo.aggregate(Episode, :max, :updated_at)
  end
end
