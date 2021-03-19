defmodule Retro.Topics.Topic do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :description, :string
    belongs_to :topic_list, Retro.Topics.TopicList, on_replace: :nilify

    timestamps()
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:description])
    |> put_assoc(:topic_list, attrs[:topic_list])
    |> validate_required([:description, :topic_list])
  end
end
