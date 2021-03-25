defmodule RetrospectivesWeb.TopicListLiveTest do
  use RetrospectivesWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetrospectivesWeb.Test.LiveComponentHarness
  alias Retrospectives.Retros
  alias Retrospectives.Repo

  describe "render" do
    test "it renders a topic list", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "some list", retro: retro})
      topic_list = Repo.preload(topic_list, [:retro, :topics])

      {:ok, _view, html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicList,
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
