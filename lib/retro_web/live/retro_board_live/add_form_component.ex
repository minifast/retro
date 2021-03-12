defmodule RetroWeb.RetroBoardLive.AddFormComponent do
  @moduledoc false
  use RetroWeb, :live_component

  alias Retro.RetroBoards
  alias Retro.RetroBoards.RetroBoard

  @impl true
  def update(%{retro_board: retro_board} = assigns, socket) do
    changeset = RetroBoards.change_retro_board(retro_board || %RetroBoard{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save_retro_board", %{"retro_board" => retro_board_params}, socket) do
    case RetroBoards.create_retro_board(retro_board_params) do
      {:ok, _retro_board} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
