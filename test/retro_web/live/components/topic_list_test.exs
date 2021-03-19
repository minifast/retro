defmodule RetroWeb.TopicListLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetroWeb.Test.LiveComponentHarness
  alias Retro.Topics
  alias Retro.Repo

  describe "render" do
    test "it renders a topic list", %{conn: conn} do
      {:ok, topic_list} = Topics.create_topic_list(%{name: "some name"})

      topic_list = Repo.preload(topic_list, :topics)

      {:ok, _view, html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicList,
            "component_assigns" => %{
              "id" => "topic-list-#{topic_list.id}",
              "topic_list" => topic_list
            }
          }
        )

      assert html =~ "#{topic_list.name}"
    end
  end
end
