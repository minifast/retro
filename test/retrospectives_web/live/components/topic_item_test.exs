defmodule RetrospectivesWeb.TopicItemLiveTest do
  use RetrospectivesWeb.ConnCase

  import Phoenix.LiveViewTest

  alias RetrospectivesWeb.Test.LiveComponentHarness
  alias Retrospectives.Retros

  describe "render" do
    test "when given a topic it renders that topic", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "some list", retro: retro})

      {:ok, topic} =
        Retros.create_topic(%{description: "some description", topic_list: topic_list})

      {:ok, _view, html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicItem,
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
