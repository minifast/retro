defmodule Retrospectives.RetrosTest do
  use Retrospectives.DataCase

  alias Retrospectives.Retros
  alias Retrospectives.Retros.Topic
  alias Retrospectives.Retros.TopicList

  def retro_fixture(attrs \\ %{}) do
    {:ok, retro} =
      attrs
      |> Retros.create_retro()

    retro
  end

  def topic_list_fixture(attrs \\ %{retro: retro_fixture()}) do
    {:ok, topic_list} =
      attrs
      |> Enum.into(%{name: "some name", retro_id: retro_fixture().id})
      |> Retros.create_topic_list()

    topic_list
  end

  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{description: "some description"})
      |> Retros.create_topic()

    topic
  end

  describe "retros" do
    alias Retrospectives.Retros.Retro

    test "list_retros/0 returns all retros" do
      retro = retro_fixture()
      assert Retros.list_retros() == [retro]
    end

    test "get_retro!/1 returns the retro with given id" do
      retro = retro_fixture() |> Repo.preload(topic_lists: :topics)
      assert Retros.get_retro!(retro.id) == retro
    end

    test "get_retro/1 returns the retro with given id" do
      retro = retro_fixture() |> Repo.preload(topic_lists: :topics)
      assert Retros.get_retro(retro.id) == retro
    end

    test "create_retro/1 with valid data creates a retro" do
      assert {:ok, %Retro{} = retro} = Retros.create_retro(%{})
    end

    test "delete_retro/1 deletes the retro" do
      retro = retro_fixture()
      assert {:ok, %Retro{}} = Retros.delete_retro(retro)
      assert_raise Ecto.NoResultsError, fn -> Retros.get_retro!(retro.id) end
    end

    test "change_retro/1 returns a retro changeset" do
      retro = retro_fixture()
      assert %Ecto.Changeset{} = Retros.change_retro(retro)
    end
  end

  describe "Topic Lists" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_topic_lists/0 returns all topic_lists" do
      topic_list =
        topic_list_fixture()
        |> Retrospectives.Repo.preload([:topics, :retro])

      assert Retros.list_topic_lists() == [topic_list]
    end

    test "get_topic_list!/1 returns the topic_list with given id" do
      topic_list = topic_list_fixture()

      assert Retros.get_topic_list!(topic_list.id).id == topic_list.id
    end

    test "get_topic_list/1 returns the topic_list with given id" do
      topic_list = topic_list_fixture()

      assert Retros.get_topic_list(topic_list.id).id == topic_list.id
    end

    test "create_topic_list/1 with valid data creates a topic_list" do
      retro = retro_fixture()

      assert {:ok, %TopicList{} = topic_list} =
               Retros.create_topic_list(Enum.into(@valid_attrs, %{retro: retro}))

      assert topic_list.name == "some name"
    end

    test "create_topic_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retros.create_topic_list(@invalid_attrs)
    end

    test "update_topic_list/2 with valid data updates the topic_list" do
      retro = retro_fixture()
      topic_list = topic_list_fixture(%{retro: retro})

      assert {:ok, %TopicList{} = topic_list} =
               Retros.update_topic_list(topic_list, Enum.into(@update_attrs, %{retro: retro}))

      assert topic_list.name == "some updated name"
    end

    test "update_topic_list/2 with invalid data returns error changeset" do
      retro = retro_fixture()
      topic_list = topic_list_fixture(%{retro: retro})

      assert {:error, %Ecto.Changeset{}} =
               Retros.update_topic_list(topic_list, Enum.into(@invalid_attrs, %{retro: retro}))

      assert topic_list == Retros.get_topic_list!(topic_list.id) |> Repo.preload([:retro])
    end

    test "update_topic_list/2 raises an error when changing the retro" do
      retro = retro_fixture()
      topic_list = topic_list_fixture(%{retro: retro})
      update_retro = retro_fixture()

      assert_raise RuntimeError, fn ->
        Retros.update_topic_list(topic_list, %{retro: update_retro})
      end
    end

    test "delete_topic_list/1 with a valid topic list deletes the topic_list" do
      topic_list = topic_list_fixture()
      assert {:ok, %TopicList{}} = Retros.delete_topic_list(topic_list)
      assert_raise Ecto.NoResultsError, fn -> Retros.get_topic_list!(topic_list.id) end
    end

    test "delete_topic_list/1 with an invalid id raises an error" do
      assert_raise Ecto.ChangeError, fn ->
        Retros.delete_topic_list(%TopicList{id: "garbage"})
      end
    end

    # does this raise if retro changes?
    test "change_topic_list/1 returns a topic_list changeset" do
      retro = retro_fixture()
      topic_list = topic_list_fixture(%{retro: retro})
      assert %Ecto.Changeset{} = Retros.change_topic_list(topic_list, %{retro: retro})
    end
  end

  describe "Topics" do
    test "list_topics/0 returns all topics" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert Retros.list_topics() |> Repo.preload(topic_list: :retro) == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert Retros.get_topic!(topic.id) |> Repo.preload(topic_list: :retro) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      topic_list = topic_list_fixture()

      assert {:ok, %Topic{} = topic} =
               Retros.create_topic(%{description: "some description", topic_list: topic_list})

      assert topic.description == "some description"
    end

    test "create_topic/1 without topic list returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retros.create_topic(%{description: "some description"})
    end

    test "create_topic/1 without description returns error changeset" do
      topic_list = topic_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Retros.create_topic(%{topic_list: topic_list})
    end

    test "create_topic/1 with invalid topic list returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Retros.create_topic(%{description: "some description", topic_list: "wrong list"})
    end

    test "create_topic/1 with invalid description returns error changeset" do
      topic_list = topic_list_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Retros.create_topic(%{description: "", topic_list: topic_list})
    end

    test "update_topic/2 with valid data updates the topic" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:ok, %Topic{} = topic} =
               Retros.update_topic(topic, %{
                 description: "some updated description",
                 topic_list: topic_list
               })

      assert topic.description == "some updated description"
    end

    test "update_topic/2 changing the topic list results in an error" do
      other_topic_list = topic_list_fixture()
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert_raise RuntimeError, fn ->
        Retros.update_topic(topic, %{topic_list: other_topic_list})
      end
    end

    test "update_topic/2 without description does not update the topic" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert {:ok, %Topic{} = topic} = Retros.update_topic(topic, %{topic_list: topic_list})
      assert topic == Retros.get_topic!(topic.id) |> Repo.preload(topic_list: :retro)
    end

    test "update_topic/2 with invalid description returns error changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:error, %Ecto.Changeset{}} =
               Retros.update_topic(topic, %{description: "", topic_list: topic_list})

      assert topic == Retros.get_topic!(topic.id) |> Repo.preload(topic_list: :retro)
    end

    test "update_topic/2 with invalid topic list returns error changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})

      assert {:error, %Ecto.Changeset{}} =
               Retros.update_topic(topic, %{
                 description: "some updated description",
                 topic_list: ""
               })

      assert topic == Retros.get_topic!(topic.id) |> Repo.preload(topic_list: :retro)
    end

    test "delete_topic/1 with a valid id deletes the topic" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert {:ok, %Topic{}} = Retros.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Retros.get_topic!(topic.id) end
    end

    test "delete_topic_list/1 with an invalid id raises an error" do
      assert_raise Ecto.ChangeError, fn ->
        Retros.delete_topic(%Topic{id: "garbage"})
      end
    end

    # does this raise if topic list changes?
    test "change_topic/1 returns a topic changeset" do
      topic_list = topic_list_fixture()
      topic = topic_fixture(%{topic_list: topic_list})
      assert %Ecto.Changeset{} = Retros.change_topic(topic, %{topic_list: topic_list})
    end
  end
end
