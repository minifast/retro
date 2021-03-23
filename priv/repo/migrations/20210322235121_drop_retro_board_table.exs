defmodule Retrospectives.Repo.Migrations.DropRetroBoardTable do
  use Ecto.Migration

  def up do
    drop_if_exists table(:retro_board)
  end

  def down do
    create table(:retro_board) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
