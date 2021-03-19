defmodule RetroWeb.PageLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Retro.Topics

  describe "Index" do
    test "disconnected and connected render", %{conn: conn} do
      {:ok, page_live, disconnected_html} = live(conn, "/")
      assert disconnected_html =~ "List Name"
      assert render(page_live) =~ "List Name"
    end

    test "it renders a topic list container", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "class=\"topic-lists\""
    end

    test "when there are topic lists it renders add topic form", %{conn: conn} do
      Topics.create_topic_list(%{name: "some name"})
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "class=\"topic-form\""
    end

    test "when there are topic lists it lists all topic lists", %{conn: conn} do
      Topics.create_topic_list(%{name: "some name"})
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "some name"
    end

    test "when there are topic lists it deletes a topic list", %{conn: conn} do
      {:ok, topic_list} = Topics.create_topic_list(%{name: "some name"})
      topic_list = Retro.Repo.preload(topic_list, :topics)

      {:ok, view, _html} = live(conn, "/")

      assert Topics.list_topic_lists() == [topic_list]

      render_click(view, "delete_topic_list", %{"topic-list-id" => "#{topic_list.id}"})

      assert Topics.list_topic_lists() == []
    end

    test "when there are topics it lists all topics", %{conn: conn} do
      {:ok, topic_list} = Topics.create_topic_list(%{name: "some name"})

      {:ok, topic} =
        Topics.create_topic(%{description: "some description", topic_list: topic_list})

      {:ok, _view, html} = live(conn, "/")

      assert html =~ "class=\"topic-items\">"
      assert html =~ "#{topic.description}"
    end

    test "when there are topics it deletes a topic", %{conn: conn} do
      {:ok, topic_list} = Topics.create_topic_list(%{name: "some name"})

      {:ok, topic} =
        Topics.create_topic(%{description: "some description", topic_list: topic_list})

      topic = Retro.Repo.preload(topic, :topic_list)

      {:ok, view, _html} = live(conn, "/")

      assert Topics.list_topics() |> Retro.Repo.preload(:topic_list) == [topic]

      render_click(view, "delete_topic", %{"topic-id" => "#{topic.id}"})

      assert Topics.list_topics() == []
    end
  end
end
