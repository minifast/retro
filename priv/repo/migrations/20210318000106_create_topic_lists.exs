defmodule Retrospectives.Repo.Migrations.CreateTopicLists do
  use Ecto.Migration

  def up do
    execute "DELETE FROM topics"
    flush()

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

  def down do
    drop index(:topics, [:description, :topic_list_id])

    alter table(:topics) do
      remove :topic_list_id
    end

    drop index(:topic_lists, [:name])

    drop table(:topic_lists)
  end
end
