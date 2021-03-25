defmodule Retrospectives.Retros.TopicList do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic_lists" do
    field :name, :string
    belongs_to :retro, Retrospectives.Retros.Retro
    has_many :topics, Retrospectives.Retros.Topic, on_delete: :delete_all

    timestamps()
  end

  def changeset(topic_list, attrs) do
    topic_list
    |> cast(attrs, [:name])
    |> put_assoc(:retro, attrs["retro"] || attrs[:retro])
    |> validate_required([:name, :retro])
  end
end
