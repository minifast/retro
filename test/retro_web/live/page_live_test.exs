defmodule RetroWeb.PageLiveTest do
  use RetroWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Retro.Topics

  describe "Index" do
    test "disconnected and connected render", %{conn: conn} do
      {:ok, page_live, disconnected_html} = live(conn, "/")
      assert disconnected_html =~ "Description"
      assert render(page_live) =~ "Description"
    end

    test "it renders a add topic form", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "id=\"add-topic-form\""
    end

    test "when there are no topics it renders an empty list", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "class=\"topic-list\">"
    end

    test "when there are topics it lists all topics", %{conn: conn} do
      {:ok, topic} = Topics.create_topic(%{description: "some description"})
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "class=\"topic-list\">"
      assert html =~ "#{topic.description}"
    end

    # We are not able to test the component because a bug
    # https://github.com/phoenixframework/phoenix_live_view/issues/1377
    @tag :skip
    test "when there are topics it deletes a topic", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      view |> render_click(:delete_topic) =~ "deleted"
    end
  end
end
