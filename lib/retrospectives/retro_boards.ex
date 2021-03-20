defmodule Retrospectives.RetroBoards do
  @moduledoc false
  import Ecto.Query, warn: false

  alias Retrospectives.Repo
  alias Retrospectives.RetroBoards.RetroBoard

  def list_retro_boards do
    Repo.all(
      from(
        rb in RetroBoard,
        order_by: [asc: fragment("lower(?)", rb.name)]
      )
    )
  end

  def get_retro_board!(id), do: Repo.get!(RetroBoard, id)

  def create_retro_board(attrs \\ %{}) do
    %RetroBoard{}
    |> RetroBoard.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:retro_board_created)
  end

  def update_retro_board(%RetroBoard{} = retro_board, attrs) do
    retro_board
    |> RetroBoard.changeset(attrs)
    |> Repo.update()
    |> broadcast(:retro_board_updated)
  end

  def delete_retro_board(%RetroBoard{} = retro_board) do
    Repo.delete(retro_board)
    |> broadcast(:retro_board_deleted)
  end

  def change_retro_board(%RetroBoard{} = retro_board, attrs \\ %{}) do
    RetroBoard.changeset(retro_board, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Retrospectives.PubSub, "retro_boards")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, retro_board}, event) do
    Phoenix.PubSub.broadcast(
      Retrospectives.PubSub,
      "retro_boards",
      {event, retro_board}
    )

    {:ok, retro_board}
  end
end
