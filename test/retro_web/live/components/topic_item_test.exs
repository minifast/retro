defmodule RetroWeb.TopicItemLiveTest do
  use RetroWeb.ConnCase

  import Phoenix.LiveViewTest

  alias RetroWeb.Test.LiveComponentHarness
  alias Retro.Topics

  describe "render" do
    test "when given a topic it renders that topic", %{conn: conn} do
      {:ok, topic_list} = Topics.create_topic_list(%{name: "some list"})

      {:ok, topic} =
        Topics.create_topic(%{description: "some description", topic_list: topic_list})

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
  end
end
