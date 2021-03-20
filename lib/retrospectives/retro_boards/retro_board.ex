defmodule Retrospectives.RetroBoards.RetroBoard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "retro_boards" do
    field :name, :string

    timestamps()
  end

  def changeset(retro_board, attrs) do
    retro_board
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
