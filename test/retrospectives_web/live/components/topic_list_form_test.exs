defmodule RetroWeb.TopicListFormLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetroWeb.Test.LiveComponentHarness
  alias Retro.Topics

  describe "TopicListForm" do
    test "when submitting an invalid changest displays an error message", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicListForm,
            "component_assigns" => %{
              "id" => "topic-list-form-1"
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic_list" => %{"name" => ""}}) =~ "can&#39;t be blank"
    end

    test "when submitting a valid changest adds a new topic list", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicListForm,
            "component_assigns" => %{
              "id" => "topic-list-form-1"
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic_list" => %{"name" => "sweet!"}})

      new_topic_list = Topics.list_topic_lists() |> List.last()

      assert new_topic_list.name == "sweet!"
    end
  end
end
