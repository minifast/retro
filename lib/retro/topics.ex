defmodule Retro.Topics do
  @moduledoc false
  import Ecto.Query, warn: false

  alias Retro.Repo
  alias Retro.Topics.Topic
  alias Retro.Topics.TopicList

  def list_topic_lists do
    Repo.all(
      from(
        t in TopicList,
        preload: [:topics],
        order_by: [asc: fragment("lower(?)", t.name)]
      )
    )
  end

  def get_topic_list!(id), do: Repo.get!(TopicList, id)
  def get_topic_list(id), do: Repo.get(TopicList, id)

  def create_topic_list(attrs \\ %{}) do
    %TopicList{}
    |> TopicList.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:topic_list_created)
  end

  def update_topic_list(%TopicList{} = topic_list, attrs) do
    topic_list
    |> TopicList.changeset(attrs)
    |> Repo.update()
    |> broadcast(:topic_list_updated)
  end

  def delete_topic_list(%TopicList{} = topic_list) do
    Repo.delete(topic_list)
    |> broadcast(:topic_list_deleted)
  end

  # def delete_topic_list_by_id(id) do
  #   Repo.delete(%TopicList{id: id})
  #   |> broadcast(:topic_list_deleted)
  # end

  def change_topic_list(%TopicList{} = topic_list, attrs \\ %{}) do
    TopicList.changeset(topic_list, attrs)
  end

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

  def subscribe_topic_lists do
    Phoenix.PubSub.subscribe(Retro.PubSub, "topic_lists")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, topic_list}, event) do
    Phoenix.PubSub.broadcast(
      Retro.PubSub,
      "topic_lists",
      {event, topic_list}
    )

    {:ok, topic_list}
  end
end
