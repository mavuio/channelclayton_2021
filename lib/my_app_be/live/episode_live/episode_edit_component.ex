defmodule MyAppBe.EpisodeLive.EpisodeEditComponent do
  @moduledoc false
  use MyAppBe, :live_component

  alias MyApp.Episodes
  alias MyApp.Episode
  alias MyApp.Repo

  @impl true
  def update(assigns, socket) do
    rec =
      case assigns.rec_id do
        "new" -> generate_default_rec(assigns)
        rec_id -> Episodes.get_episode(MavuUtils.to_int(rec_id))
      end

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(
        rec: rec,
        changeset: get_changeset(rec, %{})
      )
    }
  end

  @impl true
  def handle_event("validate", %{"fdata" => incoming_data} = _msg, socket) do
    changeset =
      socket.assigns.rec
      |> get_changeset(incoming_data)
      |> Map.put(:action, :validate)
      |> IO.inspect(label: "mwuits-debug 2021-05-31_20:29 ")

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"fdata" => incoming_data}, %{assigns: %{rec_id: "new"}} = socket) do
    socket.assigns.rec
    |> get_changeset(incoming_data)
    |> Repo.insert()
    |> case do
      {:ok, _reservation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Episode created successfully")
         |> push_patch(to: return_path(socket))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("save", %{"fdata" => incoming_data}, socket) do
    socket.assigns.rec
    |> get_changeset(incoming_data)
    |> Repo.update()
    |> case do
      {:ok, _reservation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Episode updated successfully")
         |> push_patch(to: return_path(socket))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("modal_hide", _, socket) do
    {:noreply,
     socket
     |> push_patch(to: return_path(socket))}
  end

  def get_changeset(%Episode{} = model, params \\ %{}) do
    Episode.changeset(model, params)
  end

  def return_path(socket) do
    socket.assigns.base_path.(%{})
  end

  def generate_default_rec(_assigns) do
    %Episode{
      num: "01"
    }
  end
end
