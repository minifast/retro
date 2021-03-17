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
    <%= f = form_for @topic, "#",
      id: "add-topic-form",
      phx_submit: :save,
      phx_target: @myself %>

      <%= label f, :description %>
      <%= textarea f, :description %>
      <%= error_tag f, :description %>

      <%= submit "Save" %>
    </form>
    """
  end

  @impl true
  def handle_event("save", %{"topic" => topic_params}, socket) do
    case Topics.create_topic(topic_params) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end
  end
end
