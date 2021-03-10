defmodule Retro.Topics.Topic do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :description, :string

    timestamps()
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
