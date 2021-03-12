defmodule Retro.RetroBoards do
  @moduledoc false
  import Ecto.Query, warn: false

  alias Retro.Repo
  alias Retro.RetroBoards.RetroBoard

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
  end

  def update_retro_board(%RetroBoard{} = retro_board, attrs) do
    retro_board
    |> RetroBoard.changeset(attrs)
    |> Repo.update()
  end

  def delete_retro_board(%RetroBoard{} = retro_board) do
    Repo.delete(retro_board)
  end

  def change_retro_board(%RetroBoard{} = retro_board, attrs \\ %{}) do
    RetroBoard.changeset(retro_board, attrs)
  end
end
