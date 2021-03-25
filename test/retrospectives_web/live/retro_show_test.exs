defmodule RetrospectivesWeb.RetrosShowLiveTest do
  use RetrospectivesWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Retrospectives.Retros

  describe "Show" do
    test "when there is a retro it displays the retro", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()
      {:ok, _view, html} = live(conn, "/retros/#{retro.id}")

      assert html =~ "Retro #{retro.id}"

      assert html =~
               "#{retro.inserted_at.month}/#{retro.inserted_at.day}/#{retro.inserted_at.year} at #{
                 retro.inserted_at.hour
               }:#{retro.inserted_at.minute}"
    end

    test "when there is a retro submitting the topic list form creates a topic list", %{
      conn: conn
    } do
      {:ok, retro} = Retros.create_retro()
      {:ok, view, _html} = live(conn, "/retros/#{retro.id}")

      assert view
             |> element("form.topic-list-form")
             |> render_submit(%{"topic_list" => %{"name" => "Happy"}})

      new_topic_list = Retros.list_topic_lists() |> List.last()
      assert new_topic_list.name == "Happy"
      assert render(view) =~ "Happy"
    end

    test "when the retro has topic lists it displays the topic lists", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()
      Retros.create_topic_list(%{name: "Happy", retro: retro})
      {:ok, _view, html} = live(conn, "/retros/#{retro.id}")

      assert html =~ "Happy"
    end

    test "when there is a retro and a topic list clicking delete deletes a topic list", %{
      conn: conn
    } do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "Happy", retro: retro})
      {:ok, view, _html} = live(conn, "/retros/#{retro.id}")

      assert render(view) =~ "Happy"
      render_click(view, "delete_topic_list", %{"topic-list-id" => "#{topic_list.id}"})
      refute render(view) =~ "Happy"
      assert_raise Ecto.NoResultsError, fn -> Retros.get_topic_list!(topic_list.id) end
    end

    test "when there is a retro and a topic list submitting the topic form creates a topic", %{
      conn: conn
    } do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "Happy", retro: retro})
      {:ok, view, _html} = live(conn, "/retros/#{retro.id}")

      assert view
             |> element("form.topic-form")
             |> render_submit(%{
               "topic" => %{
                 "topic_list_id" => topic_list.id,
                 "description" => "I loved the bagels"
               }
             })

      assert render(view) =~ "I loved the bagels"
    end

    test "when there is a retro with a topic list and topic, clicking delete deletes the topic",
         %{conn: conn} do
      {:ok, retro} = Retros.create_retro()
      {:ok, topic_list} = Retros.create_topic_list(%{name: "Happy", retro: retro})
      {:ok, topic} = Retros.create_topic(%{description: "good bagels", topic_list: topic_list})
      {:ok, view, _html} = live(conn, "/retros/#{retro.id}")

      assert render(view) =~ "good bagels"
      render_click(view, "delete_topic", %{"topic-id" => "#{topic.id}"})
      refute render(view) =~ "good bagels"
      assert_raise Ecto.NoResultsError, fn -> Retros.get_topic!(topic.id) end
    end
  end
end
