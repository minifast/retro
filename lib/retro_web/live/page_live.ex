defmodule RetroWeb.PageLive do
  @moduledoc false
  use RetroWeb, :live_view
  alias Retro.Topics
  alias Retro.Topics.Topic

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:topic, Topics.change_topic(%Topic{}))
      |> assign(:topics, Topics.list_topics())

    {:ok, socket}
  end
end
