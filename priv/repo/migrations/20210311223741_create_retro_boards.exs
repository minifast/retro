defmodule Retro.Repo.Migrations.CreateRetroBoards do
  use Ecto.Migration

  def change do
    create table(:retro_board) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
