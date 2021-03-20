defmodule Retrospectives.TopicsTest do
  use Retrospectives.DataCase

  alias Retrospectives.Topics
  alias Retrospectives.Topics.Topic
  alias Retrospectives.Topics.TopicList

  def topic_list_fixture(attrs \\ %{}) do
    {:ok, topic_list} =
      attrs
      |> Enum.into(%{name: "some name"})
      |> Topics.create_topic_list()

    topic_list
  end

  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{description: "some description"})
      |> Topics.create_topic()

    topic
  end

  describe "topic_lists" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_topic_lists/0 returns all topic_lists" do
      topic_list = topic_list_fixture() |> Retrospectives.Repo.preload(:topics)
      assert Topics.list_topic_lists() == [topic_list]
    end

    test "get_topic_list!/1 returns the topic_list with given id" do
      topic_list = topic_list_fixture()
      assert Topics.get_topic_list!(topic_list.id) == topic_list
    end

    test "get_topic_list/1 returns the topic_list with given id" do
      topic_list = topic_list_fixture()
      assert Topics.get_topic_list(topic_list.id) == topic_list
    end

    test "create_topic_list/1 with valid data creates a topic_list" do
      assert {:ok, %TopicList{} = topic_list} = Topics.create_topic_list(@valid_attrs)
      assert topic_list.name == "some name"
    end

    test "create_topic_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic_list(@invalid_attrs)
    end

    test "update_topic_list/2 with valid data updates the topic_list" do
      topic_list = topic_list_fixture()

      assert {:ok, %TopicList{} = topic_list} =
               Topics.update_topic_list(topic_list, @update_attrs)

      assert topic_list.name == "some updated name"
    end

    test "update_topic_list/2 with invalid data returns error changeset" do
      topic_list = topic_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic_list(topic_list, @invalid_attrs)
      assert topic_list == Topics.get_topic_list!(topic_list.id)
    end

    test "delete_topic_list/1 with a valid id deletes the topic_list" do
      topic_list = topic_list_fixture()
      assert {:ok, %TopicList{}} = Topics.delete_topic_list(topic_list.id)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic_list!(topic_list.id) end
    end

    test "delete_topic_list/1 with an invalid id raises an error" do
      assert_raise Ecto.ChangeError, fn ->
        Topics.delete_topic_list("garbage")
      end
    end

    test "change_topic_list/1 returns a topic_list changeset" do
      topic_list = topic_list_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic_list(topic_list)
    end
  end

  describe "topics" do
    test "list_topics/0 returns all topics" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert Topics.list_topics() |> Repo.preload(:topic_list) == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert Topics.get_topic!(topic.id) |> Repo.preload(:topic_list) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      topic_list = topic_list_fixture()

      assert {:ok, %Topic{} = topic} =
               Topics.create_topic(%{description: "some description", topic_list: topic_list})

      assert topic.description == "some description"
    end

    test "create_topic/1 without topic list returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic(%{description: "some description"})
    end

    test "create_topic/1 without description returns error changeset" do
      topic_list = topic_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic(%{topic_list: topic_list})
    end

    test "create_topic/1 with invalid topic list returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Topics.create_topic(%{description: "some description", topic_list: "wrong list"})
    end

    test "create_topic/1 with invalid description returns error changeset" do
      topic_list = topic_list_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Topics.create_topic(%{description: "", topic_list: topic_list})
    end

    test "update_topic/2 with valid data updates the topic" do
      other_topic_list = topic_list_fixture()
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:ok, %Topic{} = topic} =
               Topics.update_topic(topic, %{
                 description: "some updated description",
                 topic_list: other_topic_list
               })

      assert topic.description == "some updated description"
      assert topic.topic_list.id == other_topic_list.id
    end

    test "update_topic/2 without description does not update the topic" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert {:ok, %Topic{} = topic} = Topics.update_topic(topic, %{topic_list: topic_list})
      assert topic == Topics.get_topic!(topic.id) |> Repo.preload(:topic_list)
    end

    test "update_topic/2 without topic list returns error changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:error, %Ecto.Changeset{}} =
               Topics.update_topic(topic, %{description: "some updated description"})

      assert topic == Topics.get_topic!(topic.id) |> Repo.preload(:topic_list)
    end

    test "update_topic/2 with invalid description returns error changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:error, %Ecto.Changeset{}} =
               Topics.update_topic(topic, %{description: "", topic_list: topic_list})

      assert topic == Topics.get_topic!(topic.id) |> Repo.preload(:topic_list)
    end

    test "update_topic/2 with invalid topic list returns error changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:error, %Ecto.Changeset{}} =
               Topics.update_topic(topic, %{
                 description: "some updated description",
                 topic_list: ""
               })

      assert topic == Topics.get_topic!(topic.id) |> Repo.preload(:topic_list)
    end

    test "delete_topic/1 with a valid id deletes the topic" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert {:ok, %Topic{}} = Topics.delete_topic(topic.id)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic!(topic.id) end
    end

    test "delete_topic_list/1 with an invalid id raises an error" do
      assert_raise Ecto.ChangeError, fn ->
        Topics.delete_topic("garbage")
      end
    end

    test "change_topic/1 returns a topic changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert %Ecto.Changeset{} = Topics.change_topic(topic)
    end
  end
end
