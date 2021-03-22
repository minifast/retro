defmodule RetrospectivesWeb.TopicForm do
  @moduledoc false
  use RetrospectivesWeb, :live_component
  alias Retrospectives.Topics
  alias Retrospectives.Topics.Topic

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :topic, Topics.change_topic(%Topic{}))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @topic, "#",
      class: "topic-form",
      phx_submit: :add_topic,
      phx_target: @myself %>

      <%= hidden_input f, :topic_list_id, value: @topic_list_id, id: nil %>
      <%= textarea f, :description, id: nil, class: "topic-form__field" %>
      <%= error_tag f, :description %>
      <%= error_tag f, :topic_list %>
      <%= submit "Add Topic" %>
    """
  end

  @impl true
  def handle_event("add_topic", %{"topic" => topic_params}, socket) do
    topic_list = Topics.get_topic_list(topic_params["topic_list_id"])

    case Topics.create_topic(%{
           description: topic_params["description"],
           topic_list: topic_list
         }) do
      {:ok, topic} ->
        # we need to assign the topic twice to re-render the component and clear the description
        socket = assign(socket, :topic, topic)
        {:noreply, assign(socket, :topic, Topics.change_topic(%Topic{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end
  end
end
