defmodule RetrospectivesWeb.RetrosIndexLiveTest do
  use RetrospectivesWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Retrospectives.Retros

  describe "Index" do
    test "disconnected and connected render", %{conn: conn} do
      {:ok, page_live, disconnected_html} = live(conn, "/retros")
      assert disconnected_html =~ "<h1>Retros</h1>"
      assert render(page_live) =~ "Retros"
    end

    test "when there are retros it lists all retros", %{conn: conn} do
      {:ok, retro} = Retros.create_retro()

      {:ok, _view, html} = live(conn, "/retros")

      assert html =~ "href=\"/retros/#{retro.id}\">Retro #{retro.id}</a>"

      assert html =~
               "#{retro.inserted_at.month}/#{retro.inserted_at.day}/#{retro.inserted_at.year} at #{
                 retro.inserted_at.hour
               }:#{retro.inserted_at.minute}"
    end

    test "when clicking add retro, adds a retro and redirects", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/retros")
      render_click(view, "add_retro")

      retros = Retros.list_retros()
      retro = List.last(retros)

      assert length(retros) == 1
      assert_redirected(view, "/retros/#{retro.id}")
    end
  end
end
