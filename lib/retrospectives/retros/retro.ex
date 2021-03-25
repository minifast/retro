defmodule Retrospectives.Retros.Retro do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "retros" do
    has_many :topic_lists, Retrospectives.Retros.TopicList, on_delete: :delete_all
    timestamps()
  end

  def changeset(retro, attrs) do
    retro
    |> cast(attrs, [])
    |> validate_required([])
  end
end
