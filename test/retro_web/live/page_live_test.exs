defmodule RetroWeb.PageLiveTest do
  use RetroWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Retro!"
    assert render(page_live) =~ "Welcome to Retro!"
  end
end
