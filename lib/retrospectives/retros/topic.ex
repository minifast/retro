defmodule Retrospectives.Retros.Topic do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :description, :string
    belongs_to :topic_list, Retrospectives.Retros.TopicList

    timestamps()
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:description])
    |> put_assoc(:topic_list, attrs[:topic_list])
    |> validate_required([:description])
    |> validate_required([:topic_list], message: "List can't be blank")
  end
end
