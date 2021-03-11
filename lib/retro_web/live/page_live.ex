defmodule RetroWeb.PageLive do
  @moduledoc false
  use RetroWeb, :live_view
  alias Retro.Topics
  alias Retro.Topics.Topic

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Topics.subscribe()

    socket =
      socket
      |> assign(:topic, Topics.change_topic(%Topic{}))
      |> assign(:topics, Topics.list_topics())

    {:ok, socket}
  end

  @impl true
  def handle_info({:topic_created, _topic}, socket) do
    {:noreply, assign(socket, :topics, Topics.list_topics())}
  end

  @impl true
  def handle_info({:topic_updated, _topic}, socket) do
    {:noreply, assign(socket, :topics, Topics.list_topics())}
  end

  @impl true
  def handle_info({:topic_deleted, _topic}, socket) do
    {:noreply, assign(socket, :topics, Topics.list_topics())}
  end

  @impl true
  def handle_event("delete_topic", %{"topic-id" => topic_id}, socket) do
    topic = Topics.get_topic!(topic_id)

    case Topics.delete_topic(topic) do
      {:ok, _topic} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end

    {:noreply, socket}
  end
end
