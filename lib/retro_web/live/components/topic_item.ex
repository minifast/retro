defmodule RetroWeb.TopicItem do
  @moduledoc false
  use RetroWeb, :live_component
  alias Retro.Topics

  @impl true
  def render(assigns) do
    ~L"""
    <article class="topic">
      <section class="topic__description">
        <%= @topic.description %>
      </section>
      <section class="topic__delete">
        <%=
          link(
            gettext("Delete Topic"),
            to: "#",
            phx_click: :delete_topic,
            phx_value_topic_id: @topic.id,
            data: [
              confirm: gettext("Are you sure you want to delete \"%{description}\"?",
              description: @topic.description)
            ]
          )
        %>
      </section>
    </article>
    """
  end
end
