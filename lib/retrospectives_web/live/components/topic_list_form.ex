defmodule RetrospectivesWeb.TopicListForm do
  @moduledoc false
  use RetrospectivesWeb, :live_component
  alias Retrospectives.Topics
  alias Retrospectives.Topics.TopicList

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :topic_list, Topics.change_topic_list(%TopicList{}))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @topic_list, "#",
      class: "topic-list-form",
      phx_submit: :add_topic_list,
      phx_target: @myself %>

      <%= label f, :name, "List Name", class: "topic-list-form__label" %>

      <section class="topic-list-form__field">
        <%= text_input f, :name %>
        <%= error_tag f, :name %>
      </section>

      <section class="topic-list-form__button">
        <%= submit "Add List" %>
      </section>
    """
  end

  @impl true
  def handle_event("add_topic_list", %{"topic_list" => topic_list_params}, socket) do
    case Topics.create_topic_list(topic_list_params) do
      {:ok, _topic} ->
        {:noreply,
         socket
         |> push_redirect(to: Routes.page_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic_list, changeset)}
    end
  end
end
