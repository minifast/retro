defmodule RetroWeb.TopicListLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetroWeb.Test.LiveComponentHarness
  alias Retro.Topics

  describe "render" do
    test "when there are no topics it renders an empty list", %{conn: conn} do
      {:ok, _view, html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-list-1",
              "topics" => Topics.list_topics()
            }
          }
        )

      assert html =~ "class=\"topic-list\">"
      refute html =~ "<li"
    end

    test "when there are topics it lists all topics", %{conn: conn} do
      {:ok, topic} = Topics.create_topic(%{description: "some description"})

      {:ok, _view, html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-list-4",
              "topics" => Topics.list_topics()
            }
          }
        )

      assert html =~ "<tr id=\"topic-#{topic.id}\"><td>#{topic.description}</td><td>"
    end

    # We are not able to test the component because a bug
    # https://github.com/phoenixframework/phoenix_live_view/issues/1377
    @tag :skip
    test "when there are topics, clicking delete deletes a topic", %{conn: conn} do
      {:ok, _topic} = Topics.create_topic(%{description: "some description"})

      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-list-1",
              "topics" => Topics.list_topics()
            }
          }
        )

      assert view |> render_click("Delete") =~ "deleted"
    end
  end
end
