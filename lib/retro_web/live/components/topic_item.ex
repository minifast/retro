defmodule RetroWeb.TopicItem do
  @moduledoc false
  use RetroWeb, :live_component
  alias Retro.Topics

  @impl true
  def render(assigns) do
    ~L"""
    <tr id="topic-<%= @topic.id %>">
      <td width="70%">
        <%= @topic.description %>
      </td>
      <td style="text-align: center">
        <span>
          <%=
            link(
              gettext("Delete"),
              to: "#",
              phx_target: @myself,
              phx_click: :delete_topic,
              phx_value_topic_id: @topic.id,
              data: [
                confirm: gettext("Are you sure you want to delete \"%{description}\"?",
                description: @topic.description)
              ]
            )
          %>
        </span>
      </td>
    </tr>
    """
  end

  @impl true
  def handle_event("delete_topic", %{"topic-id" => topic_id}, socket) do
    topic = Topics.get_topic!(topic_id)

    case Topics.delete_topic(topic) do
      {:ok, _topic} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :topic, changeset)}
    end

    {:noreply, socket}
  end
end
