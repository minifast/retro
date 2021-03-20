defmodule Retrospectives.Repo.Migrations.CreateTopicLists do
  use Ecto.Migration

  def change do
    Retrospectives.Repo.delete_all(Retrospectives.Topics.Topic)

    create table(:topic_lists) do
      add :name, :string, null: false

      timestamps()
    end

    create index(:topic_lists, [:name])

    alter table(:topics) do
      add :topic_list_id, references("topic_lists", on_delete: :delete_all), null: false
    end

    create index(:topics, [:description, :topic_list_id])
  end
end
