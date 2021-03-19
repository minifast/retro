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
      class: "add-topic-list-form",
      phx_submit: :add_topic,
      phx_target: @myself %>

      <%= hidden_input f, :topic_list_id, value: @topic_list_id, id: nil %>
      <%= textarea f, :description, id: nil %>
      <%= error_tag f, :description %>
      <%= error_tag f, :topic_list %>
      <%= submit "Add Topic" %>
    </form>
    """
  end

  @impl true
  def handle_event("add_topic", %{"topic" => topic_params}, socket) do
    topic_list = Topics.get_topic_list(topic_params["topic_list_id"])

    case Topics.create_topic(%{
           description: topic_params["description"],
           topic_list: topic_list
         }) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> push_redirect(to: Routes.page_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end
  end
end
