defmodule RetroWeb.TopicForm do
  @moduledoc false
  use RetroWeb, :live_component
  alias Retro.Topics
  alias Retro.Topics.Topic

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :topic, Topics.change_topic(%Topic{}))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @topic, "#", [phx_submit: :save, phx_target: @myself] %>
      <%= label f, :description %>
      <%= textarea f, :description %>
      <%= error_tag f, :description %>

      <%= submit "Save" %>
    </form>
    """
  end

  @impl true
  def handle_event("save", params, socket) do
    case Topics.create_topic(params["topic"]) do
      {:ok, _topic} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end
  end
end
