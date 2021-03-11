defmodule Harness do
  use RetroWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    assigns = session["component_assigns"] |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    socket =
      socket
      |> assign(:component, session["component"])
      |> assign(:component_assigns, assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, :"#{@component}", @component_assigns %>
    """
  end
end

defmodule RetroWeb.TopicListLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Retro.Topics
  alias Retro.Topics.Topic

  describe "Index" do
    test "when there are no topics it renders an empty list", %{conn: conn} do
      {:ok, _view, html} =
        live_isolated(conn, Harness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic" => Topics.change_topic(%Topic{}),
              "topics" => Topics.list_topics()
            }
          }
        )

      assert html =~ "class=\"topic-list\">"
      assert html =~ "<textarea"
      assert html =~ "<button"
      refute html =~ "<li"
    end

    test "when there are topics it lists all topics", %{conn: conn} do
      {:ok, topic} = Topics.create_topic(%{description: "some description"})

      {:ok, _view, html} =
        live_isolated(conn, Harness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic" => Topics.change_topic(%Topic{}),
              "topics" => Topics.list_topics()
            }
          }
        )

      assert html =~ "<tr id=\"topic-#{topic.id}\"><td>#{topic.description}</td><td>"
    end

    test "when no attributes are set for the changeset it shows an error", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, Harness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic" => Topics.change_topic(%Topic{}),
              "topics" => Topics.list_topics()
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{}) =~ "can&#39;t be blank"
    end

    test "when submitting valid changest adds a new topic", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, Harness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic" => Topics.change_topic(%Topic{}),
              "topics" => Topics.list_topics()
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic" => %{"description" => "sweet!"}})

      new_topic = Topics.list_topics() |> List.last()

      assert new_topic.description == "sweet!"
    end
  end
end
