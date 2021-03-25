defmodule Retrospectives.Repo.Migrations.AddTopicListsToRetro do
  use Ecto.Migration

  def change do
    Retrospectives.Repo.delete_all(Retrospectives.Topics.Topic)
    Retrospectives.Repo.delete_all(Retrospectives.Topics.TopicList)

    alter table(:topic_lists) do
      add :retro_id, references("retros", on_delete: :delete_all), null: false
    end

    create index(:topic_lists, [:retro_id])
  end
end
