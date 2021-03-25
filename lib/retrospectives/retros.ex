defmodule Retrospectives.Retros do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Retrospectives.Repo
  alias Retrospectives.Retros.Retro
  alias Retrospectives.Retros.TopicList
  alias Retrospectives.Retros.Topic

  def list_retros do
    Repo.all(Retro)
  end

  def get_retro!(id), do: Repo.get!(Retro, id) |> Repo.preload(topic_lists: :topics)
  def get_retro(id), do: Repo.get(Retro, id) |> Repo.preload(topic_lists: :topics)

  def create_retro(attrs \\ %{}) do
    %Retro{}
    |> Retro.changeset(attrs)
    |> Repo.insert()
    |> broadcast_retros(:retro_created)
  end

  def update_retro(%Retro{} = retro, attrs) do
    retro
    |> Retro.changeset(attrs)
    |> Repo.update()
    |> broadcast_retros(:retro_updated)
  end

  def delete_retro(%Retro{} = retro) do
    Repo.delete(retro)
  end

  def change_retro(%Retro{} = retro, attrs \\ %{}) do
    Retro.changeset(retro, attrs)
  end

  def subscribe_to_retros do
    Phoenix.PubSub.subscribe(Retrospectives.PubSub, "retros")
  end

  def subscribe_to_retro(retro_id) do
    Phoenix.PubSub.subscribe(Retrospectives.PubSub, "retros:#{retro_id}")
  end

  defp broadcast_retros({:error, _reason} = error, _event), do: error

  # this sends a retro, not retros
  defp broadcast_retros({:ok, retro}, event) do
    Phoenix.PubSub.broadcast(
      Retrospectives.PubSub,
      "retros",
      {event, retro}
    )

    {:ok, retro}
  end

  def broadcast_retro({:error, _reason} = error, _event), do: error

  def broadcast_retro({:ok, %Retro{} = retro}, event) do
    Phoenix.PubSub.broadcast(
      Retrospectives.PubSub,
      "retros:#{retro.id}",
      {event, retro}
    )

    {:ok, retro}
  end

  # def broadcast_retro({:ok, resource}, _) do
  #   {:ok, resource}
  # end

  def broadcast_retro({:ok, %TopicList{} = topic_list}, event) do
    # where is best to preload?
    topic_list = Repo.preload(topic_list, :retro)
    retro = topic_list.retro

    Phoenix.PubSub.broadcast(
      Retrospectives.PubSub,
      "retros:#{retro.id}",
      {event, retro}
    )

    {:ok, topic_list}
  end

  def broadcast_retro({:ok, %Topic{} = topic}, event) do
    # where is best to preload?
    topic = Repo.preload(topic, topic_list: :retro)
    retro = topic.topic_list.retro

    Phoenix.PubSub.broadcast(
      Retrospectives.PubSub,
      "retros:#{retro.id}",
      {event, retro}
    )

    {:ok, topic}
  end

  def list_topic_lists do
    TopicList
    |> Repo.all()
    |> Repo.preload([
      :retro,
      topics: from(t in Topic, order_by: fragment("lower(?)", t.description))
    ])
  end

  def get_topic_list!(id), do: Repo.get!(TopicList, id)
  def get_topic_list(id), do: Repo.get(TopicList, id)

  def create_topic_list(attrs \\ %{}) do
    %TopicList{}
    |> TopicList.changeset(attrs)
    |> Repo.insert()
    |> broadcast_retro(:retro_updated)
  end

  def update_topic_list(%TopicList{} = topic_list, attrs) do
    topic_list
    |> TopicList.changeset(attrs)
    |> Repo.update()
    |> broadcast_retro(:retro_updated)
  end

  def delete_topic_list(%TopicList{} = topic_list) do
    Repo.delete(topic_list)
    |> broadcast_retro(:retro_updated)
  end

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
    |> broadcast_retro(:retro_updated)
  end

  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
    |> broadcast_retro(:retro_updated)
  end

  def delete_topic(topic) do
    Repo.delete(topic)
    |> broadcast_retro(:retro_updated)
  end

  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end
end
