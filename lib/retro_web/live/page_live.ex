defmodule RetroWeb.PageLive do
  @moduledoc false
  use RetroWeb, :live_view
  alias Retro.Topics
  alias Retro.Topics.Topic

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Topics.subscribe()

    {:ok, assign(socket, :topics, Topics.list_topics())}
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
end
