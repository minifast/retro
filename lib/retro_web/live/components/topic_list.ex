defmodule RetroWeb.TopicList do
  @moduledoc false
  use RetroWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <article class="topic-list">
        <section class="topic-list__name">
          <%= @topic_list.name %>
        </section>
        <section class="topic-list__delete">
          <%=
            link(
              gettext("Delete List"),
              to: "#",
              phx_click: :delete_topic_list,
              phx_value_topic_list_id: @topic_list.id,
              data: [
                confirm: gettext("Are you sure you want to delete \"%{name}\"?",
                name: @topic_list.name)
              ]
            )
          %>
        </section>
      </article>

      <section>
        <ul class="topic-items">
          <%= for topic <- @topic_list.topics do %>
            <li class="topic-item"><%= live_component socket, RetroWeb.TopicItem, topic: topic %></li>
          <% end %>
        </ul>
      </section>

      <section>
        <%= live_component @socket, RetroWeb.TopicForm, id: "topic-form-list-#{@topic_list.id}", topic_list_id: @topic_list.id %>
      </section>
    </section>
    """
  end
end
