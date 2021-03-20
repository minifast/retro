defmodule RetrospectivesWeb.RetroBoardLive.FormComponent do
  @moduledoc false
  use RetrospectivesWeb, :live_component

  alias Retrospectives.RetroBoards
  alias Retrospectives.RetroBoards.RetroBoard

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
    save_retro_board(socket, socket.assigns.action, retro_board_params)
  end

  defp save_retro_board(socket, :edit, retro_board_params) do
    case RetroBoards.update_retro_board(socket.assigns.retro_board, retro_board_params) do
      {:ok, _retro_board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Retro board updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_retro_board(socket, :new, retro_board_params) do
    case RetroBoards.create_retro_board(retro_board_params) do
      {:ok, _retro_board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Retro board created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
