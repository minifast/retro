defmodule Retrospectives.Repo.Migrations.AddTopicListsToRetro do
  use Ecto.Migration

  def up do
    execute "DELETE FROM topics"
    flush()
    execute "DELETE FROM topic_lists"
    flush()

    alter table(:topic_lists) do
      add :retro_id, references("retros", on_delete: :delete_all), null: false
    end

    create index(:topic_lists, [:retro_id])
  end

  def down do
    drop index(:topic_lists, [:retro_id])
    alter table(:topic_lists) do
      remove :retro_id
    end
  end
end
