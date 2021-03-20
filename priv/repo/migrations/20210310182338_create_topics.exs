defmodule Retrospectives.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :description, :string, null: false

      timestamps()
    end
  end
end
