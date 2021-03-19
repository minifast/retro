defmodule Retro.Topics.TopicTest do
  use Retro.DataCase
  alias Retro.Topics.Topic
  alias Retro.Topics.TopicList

  describe "schema/2" do
    @topic %Topic{}

    test "has a description key" do
      assert Map.has_key?(@topic, :description)
    end

    test "belongs to a topic list" do
      assert Map.has_key?(@topic, :topic_list_id)
    end
  end

  describe "changeset/2" do
    @topic_list %TopicList{name: 'Cool List'}

    test "sets the description" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy", topic_list: @topic_list})
      assert changeset.changes.description == "Happy"
    end

    test "sets the topic list" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy", topic_list: @topic_list})
      assert changeset.changes.topic_list.data.id == @topic_list.id
    end

    test "returns no errors when attributes are valid" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy", topic_list: @topic_list})
      assert changeset.errors == []
    end

    test "returns an error when there is no description" do
      changeset = Topic.changeset(%Topic{}, %{topic_list: @topic_list})
      %{description: description_errors} = errors_on(changeset)
      assert ["can't be blank"] == description_errors
    end

    test "returns an error when there is no topic list" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy"})
      %{topic_list: topic_list_errors} = errors_on(changeset)
      assert ["List can't be blank"] == topic_list_errors
    end

    test "returns an error when the topic list is invalid" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy", topic_list: ""})
      %{topic_list: topic_list_errors} = errors_on(changeset)
      assert ["is invalid"] == topic_list_errors
    end
  end
end
