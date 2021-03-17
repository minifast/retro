defmodule RetroWeb.TopicFormLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetroWeb.Test.LiveComponentHarness
  alias Retro.Topics

  describe "TopicForm" do
    test "when submitting an invalid changest displays an error message", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicForm,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "return_to" => "/"
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic" => %{"description" => ""}}) =~ "can&#39;t be blank"
    end

    test "when submitting a valid changest adds a new topic", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetroWeb.TopicForm,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "return_to" => "/"
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
