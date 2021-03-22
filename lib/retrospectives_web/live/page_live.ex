defmodule RetrospectivesWeb.PageLive do
  @moduledoc false
  use RetrospectivesWeb, :live_view
  alias Retrospectives.Topics

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Topics.subscribe_topic_lists()

    {:ok, assign(socket, topic_lists: Topics.list_topic_lists())}
  end

  @impl true
  def handle_info({:topic_list_created, _topic_list}, socket) do
    {:noreply, assign(socket, :topic_lists, Topics.list_topic_lists())}
  end

  @impl true
  def handle_info({:topic_list_updated, _topic_list}, socket) do
    {:noreply, assign(socket, :topic_lists, Topics.list_topic_lists())}
  end

  @impl true
  def handle_info({:topic_list_deleted, _topic_list}, socket) do
    {:noreply, assign(socket, :topic_lists, Topics.list_topic_lists())}
  end

  @impl true
  def handle_info({:topic_created, _topic_list}, socket) do
    {:noreply, assign(socket, :topic_lists, Topics.list_topic_lists())}
  end

  @impl true
  def handle_info({:topic_updated, _topic_list}, socket) do
    {:noreply, assign(socket, :topic_lists, Topics.list_topic_lists())}
  end

  @impl true
  def handle_info({:topic_deleted, _topic_list}, socket) do
    {:noreply, assign(socket, :topic_lists, Topics.list_topic_lists())}
  end

  @impl true
  def handle_event("delete_topic_list", %{"topic-list-id" => topic_list_id}, socket) do
    case Topics.delete_topic_list(String.to_integer(topic_list_id)) do
      {:ok, _topic_list} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic_list, changeset)}
    end
  end

  @impl true
  def handle_event("delete_topic", %{"topic-id" => topic_id}, socket) do
    case Topics.delete_topic(String.to_integer(topic_id)) do
      {:ok, _topic} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end
  end
end
