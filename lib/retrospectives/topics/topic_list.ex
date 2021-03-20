defmodule Retrospectives.Topics.TopicList do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic_lists" do
    field :name, :string
    has_many :topics, Retrospectives.Topics.Topic, on_delete: :delete_all

    timestamps()
  end

  def changeset(topic_list, attrs) do
    topic_list
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
