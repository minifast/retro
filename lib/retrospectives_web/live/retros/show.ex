defmodule RetrospectivesWeb.RetrosLive.Show do
  @moduledoc false

  use RetrospectivesWeb, :live_view

  alias Retrospectives.Retros

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Retros.subscribe_to_retro(id)
    retro = Retros.get_retro!(id)
    {:ok, assign(socket, retro: retro)}
  end

  @impl true
  def handle_info({:retro_updated, retro}, socket) do
    {:noreply, assign(socket, :retro, Retros.get_retro!(retro.id))}
  end

  @impl true
  def handle_event("delete_topic_list", %{"topic-list-id" => topic_list_id}, socket) do
    topic_list =
      topic_list_id
      |> String.to_integer()
      |> Retros.get_topic_list()
      |> Retrospectives.Repo.preload([:retro])

    case Retros.delete_topic_list(topic_list) do
      {:ok, _topic_list} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic_list, changeset)}
    end
  end

  @impl true
  def handle_event("delete_topic", %{"topic-id" => topic_id}, socket) do
    topic =
      topic_id
      |> String.to_integer()
      |> Retros.get_topic!()
      |> Retrospectives.Repo.preload(topic_list: :retro)

    case Retros.delete_topic(topic) do
      {:ok, _topic} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end
  end
end
