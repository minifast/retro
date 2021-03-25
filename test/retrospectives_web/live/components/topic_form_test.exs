defmodule RetrospectivesWeb.TopicFormLiveTest do
  use RetrospectivesWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetrospectivesWeb.Test.LiveComponentHarness
  alias Retrospectives.Retros

  describe "TopicForm" do
    test "when submitting an invalid changeset with no description displays an error message", %{
      conn: conn
    } do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "some list", retro: retro})

      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicForm,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic_list_id" => topic_list.id
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{
               "topic" => %{"description" => "", topic_list_id: topic_list.id}
             }) =~
               "can&#39;t be blank"
    end

    test "when submitting an invalid changeset with no topic list id displays an error message",
         %{
           conn: conn
         } do
      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicForm,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic_list_id" => "-1"
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{
               "topic" => %{"description" => "sweet!"}
             }) =~
               "List can&#39;t be blank"
    end

    test "when submitting a valid changest adds a new topic", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "some list", retro: retro})

      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicForm,
            "component_assigns" => %{
              "id" => "topic-form-1",
              "topic_list_id" => topic_list.id
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{
               "topic" => %{"description" => "sweet!", topic_list_id: topic_list.id}
             })

      new_topic = Retros.list_topics() |> List.last()

      assert new_topic.description == "sweet!"
    end
  end
end
