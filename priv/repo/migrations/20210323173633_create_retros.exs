defmodule Retrospectives.Repo.Migrations.CreateRetros do
  use Ecto.Migration

  def change do
    create table(:retros) do

      timestamps()
    end

  end
end
