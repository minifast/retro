defmodule Retro.Topics do
  @moduledoc false
  import Ecto.Query, warn: false

  alias Retro.Repo
  alias Retro.Topics.Topic

  def list_topics do
    Repo.all(
      from(
        t in Topic,
        order_by: [asc: fragment("lower(?)", t.description)]
      )
    )
  end

  def get_topic!(id), do: Repo.get!(Topic, id)

  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:topic_created)
  end

  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
    |> broadcast(:topic_updated)
  end

  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
    |> broadcast(:topic_deleted)
  end

  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Retro.PubSub, "topics")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, topic}, event) do
    Phoenix.PubSub.broadcast(
      Retro.PubSub,
      "topics",
      {event, topic}
    )

    {:ok, topic}
  end
end
