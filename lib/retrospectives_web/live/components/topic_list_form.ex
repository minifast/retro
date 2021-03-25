defmodule RetrospectivesWeb.TopicListForm do
  @moduledoc false
  use RetrospectivesWeb, :live_component
  alias Retrospectives.Retros
  alias Retrospectives.Retros.TopicList
  alias Retrospectives.Retros

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :topic_list, Retros.change_topic_list(%TopicList{}))}
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

      <section class="topic-list-form__field">
        <%= hidden_input f, :retro_id, value: @retro_id, id: nil %>
        <%= error_tag f, :retro %>
      </section>

      <section class="topic-list-form__button">
        <%= submit "Add List" %>
      </section>
    """
  end

  @impl true
  def handle_event("add_topic_list", %{"topic_list" => topic_list_params}, socket) do
    retro = Retros.get_retro(topic_list_params["retro_id"])

    case Retros.create_topic_list(%{name: topic_list_params["name"], retro: retro}) do
      {:ok, topic_list} ->
        socket =
          socket
          |> assign(:topic_list, topic_list)
          |> assign(:topic_list, Retros.change_topic_list(%TopicList{}))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic_list, changeset)}
    end
  end
end
