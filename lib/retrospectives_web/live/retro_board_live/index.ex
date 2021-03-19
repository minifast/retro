defmodule RetroWeb.RetroBoardLive.Index do
  @moduledoc false
  use RetroWeb, :live_view

  alias Retro.RetroBoards

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: RetroBoards.subscribe()

    {:ok, assign(socket, :retro_boards, RetroBoards.list_retro_boards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Retro Board")
    |> assign(:retro_board, RetroBoards.get_retro_board!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Retro Boards")
    |> assign(:retro_board, nil)
  end

  @impl true
  def handle_info({:retro_board_created, _retro_board}, socket) do
    {:noreply, assign(socket, :retro_boards, RetroBoards.list_retro_boards())}
  end

  @impl true
  def handle_info({:retro_board_updated, _retro_board}, socket) do
    {:noreply, assign(socket, :retro_boards, RetroBoards.list_retro_boards())}
  end

  @impl true
  def handle_info({:retro_board_deleted, _retro_board}, socket) do
    {:noreply, assign(socket, :retro_boards, RetroBoards.list_retro_boards())}
  end

  @impl true
  def handle_event("delete_retro_board", %{"retro-board-id" => retro_board_id}, socket) do
    retro_board = RetroBoards.get_retro_board!(retro_board_id)
    {:ok, _} = RetroBoards.delete_retro_board(retro_board)

    {:noreply, assign(socket, :retro_boards, RetroBoards.list_retro_boards())}
  end
end
