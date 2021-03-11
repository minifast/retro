defmodule RetroWeb.TopicList do
  @moduledoc false
  use RetroWeb, :live_component
  alias Retro.Topics

  @impl true
  def render(assigns) do
    ~L"""
    <%= render_form(assigns) %>
    <%= render_list(assigns) %>
    """
  end

  defp render_list(assigns) do
    ~L"""
    <table>
      <tbody id="topic-list" class="topic-list">
        <%= for topic <- @topics do %>
          <tr id="topic-<%= topic.id %>">
            <td><%= topic.description %></td>
            <td>
              <span><%= link gettext("Delete"), to: "#", phx_click: :delete_topic, phx_value_topic_id: topic.id, data: [confirm: gettext("Are you sure you want to delete \"%{description}\"?", description: topic.description)] %></span>
            </td>
          </tr>
        <% end %>
      </tbody>
    <table>
    """
  end

  defp render_form(assigns) do
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
