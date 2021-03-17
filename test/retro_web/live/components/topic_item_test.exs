defmodule RetroWeb.TopicItemLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetroWeb.Test.LiveComponentHarness
  alias Retro.Topics

  describe "render" do
    test "when given a topic it renders that topic", %{conn: conn} do
      {:ok, topic} = Topics.create_topic(%{description: "some description"})

      {:ok, _view, html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicItem,
            "component_assigns" => %{
              "id" => "topic-#{topic.id}",
              "topic" => topic
            }
          }
        )

      assert html =~ "#{topic.description}"
    end

    # We are not able to test the component because a bug
    # https://github.com/phoenixframework/phoenix_live_view/issues/1377
    @tag :skip
    test "when there are topics, clicking delete deletes a topic", %{conn: conn} do
      {:ok, topic} = Topics.create_topic(%{description: "some description"})

      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicItem,
            "component_assigns" => %{
              "id" => "topic-#{topic.id}",
              "topic" => topic
            }
          }
        )

      assert view |> render_click("Delete") =~ "deleted"
    end
  end
end
