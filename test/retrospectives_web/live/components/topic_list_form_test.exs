defmodule RetrospectivesWeb.TopicListFormLiveTest do
  use RetrospectivesWeb.ConnCase
  import Phoenix.LiveViewTest
  alias RetrospectivesWeb.Test.LiveComponentHarness
  alias Retrospectives.Retros

  describe "TopicListForm" do
    test "when submitting a changeset with no name displays an error message", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()

      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicListForm,
            "component_assigns" => %{
              "id" => "topic-list-form-1",
              "retro_id" => retro.id
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic_list" => %{"name" => "", "retro_id" => retro.id}}) =~
               "can&#39;t be blank"
    end

    test "when submitting a changeset with no retro displays an error message", %{conn: conn} do
      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicListForm,
            "component_assigns" => %{
              "id" => "topic-list-form-1",
              "retro_id" => -1
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic_list" => %{name: "sweet!"}}) =~ "can&#39;t be blank"
    end

    test "when submitting a valid changest adds a new topic list", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()

      {:ok, view, _html} =
        live_isolated(conn, LiveComponentHarness,
          session: %{
            "component" => RetrospectivesWeb.TopicListForm,
            "component_assigns" => %{
              "id" => "topic-list-form-1",
              "retro_id" => retro.id
            }
          }
        )

      assert view
             |> element("form")
             |> render_submit(%{"topic_list" => %{"name" => "sweet!"}})

      new_topic_list = Retros.list_topic_lists() |> List.last()

      assert new_topic_list.name == "sweet!"
    end
  end
end
