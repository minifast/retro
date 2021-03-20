defmodule Retrospectives.Topics.TopicListTest do
  use Retrospectives.DataCase
  alias Retrospectives.Topics.TopicList

  describe "schema/2" do
    @topic_list %TopicList{}

    test "has a name key" do
      assert Map.has_key?(@topic_list, :name)
    end

    test "has many topics" do
      assert Map.has_key?(@topic_list, :topics)
    end
  end

  describe "changeset/2" do
    test "sets the name" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "Happy"})
      assert changeset.changes.name == "Happy"
    end

    test "returns no errors when attributes are valid" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "Happy"})
      assert changeset.errors == []
    end

    test "returns an error when there is no name" do
      changeset = TopicList.changeset(%TopicList{}, %{name: ""})
      %{name: name_errors} = errors_on(changeset)
      assert ["can't be blank"] == name_errors
    end
  end
end
