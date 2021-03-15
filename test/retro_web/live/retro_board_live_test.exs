defmodule RetroWeb.RetroBoardLiveTest do
  use RetroWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Retro.RetroBoards

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:retro_board) do
    {:ok, retro_board} = RetroBoards.create_retro_board(@create_attrs)
    retro_board
  end

  defp create_retro_board(_) do
    retro_board = fixture(:retro_board)
    %{retro_board: retro_board}
  end

  describe "Index" do
    setup [:create_retro_board]

    test "lists all retro boards", %{conn: conn, retro_board: retro_board} do
      {:ok, _index_live, html} = live(conn, Routes.retro_board_index_path(conn, :index))

      assert html =~ "Retro Boards"
      assert html =~ retro_board.name
    end

    test "shows error when adding a blank name", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.retro_board_index_path(conn, :index))

      assert index_live
             |> element("#add-retro-board-form")
             |> render_submit() =~ "can&#39;t be blank"
    end

    test "adds a new retro board", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.retro_board_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#add-retro-board-form", retro_board: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.retro_board_index_path(conn, :index))

      assert html =~ "some name"
    end

    test "shows error when updating to a blank name", %{conn: conn, retro_board: retro_board} do
      {:ok, index_live, _html} = live(conn, Routes.retro_board_index_path(conn, :index))

      assert index_live
             |> element("#retro-board-#{retro_board.id} a", "Edit")
             |> render_click() =~ "Edit Retro Board"

      assert_patch(index_live, Routes.retro_board_index_path(conn, :edit, retro_board))

      assert index_live
             |> form("#retro-board-form", retro_board: @invalid_attrs)
             |> render_submit() =~ "can&#39;t be blank"
    end

    test "updates a retro board name", %{conn: conn, retro_board: retro_board} do
      {:ok, index_live, _html} = live(conn, Routes.retro_board_index_path(conn, :index))

      assert index_live
             |> element("#retro-board-#{retro_board.id} a", "Edit")
             |> render_click() =~ "Edit Retro Board"

      assert_patch(index_live, Routes.retro_board_index_path(conn, :edit, retro_board))

      {:ok, _, html} =
        index_live
        |> form("#retro-board-form", retro_board: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.retro_board_index_path(conn, :index))

      assert html =~ "Retro board updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes retro_board in listing", %{conn: conn, retro_board: retro_board} do
      {:ok, index_live, _html} = live(conn, Routes.retro_board_index_path(conn, :index))

      assert index_live
             |> element("#retro-board-#{retro_board.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#retro-board-#{retro_board.id}")
    end
  end

  describe "Show" do
    setup [:create_retro_board]

    test "displays retro_board", %{conn: conn, retro_board: retro_board} do
      {:ok, _show_live, html} = live(conn, Routes.retro_board_show_path(conn, :show, retro_board))

      assert html =~ "Show Retro Board"
      assert html =~ retro_board.name
    end

    test "shows error when updating to a blank name", %{conn: conn, retro_board: retro_board} do
      {:ok, show_live, _html} = live(conn, Routes.retro_board_show_path(conn, :show, retro_board))

      assert show_live
             |> element("a", "Edit")
             |> render_click() =~ "Edit Retro Board"

      assert_patch(show_live, Routes.retro_board_show_path(conn, :edit, retro_board))

      assert show_live
             |> form("#retro-board-form", retro_board: @invalid_attrs)
             |> render_submit() =~ "can&#39;t be blank"
    end

    test "updates retro_board within modal", %{conn: conn, retro_board: retro_board} do
      {:ok, show_live, _html} = live(conn, Routes.retro_board_show_path(conn, :show, retro_board))

      assert show_live
             |> element("a", "Edit")
             |> render_click() =~ "Edit Retro Board"

      assert_patch(show_live, Routes.retro_board_show_path(conn, :edit, retro_board))

      {:ok, _, html} =
        show_live
        |> form("#retro-board-form", retro_board: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.retro_board_show_path(conn, :show, retro_board))

      assert html =~ "Retro board updated successfully"
      assert html =~ "some updated name"
    end
  end
end
