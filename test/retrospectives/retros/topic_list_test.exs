defmodule Retrospectives.Retros.TopicListTest do
  use Retrospectives.DataCase
  alias Retrospectives.Retros.TopicList
  alias Retrospectives.Retros.Retro

  describe "schema/2" do
    @topic_list %TopicList{}

    test "has a name key" do
      assert Map.has_key?(@topic_list, :name)
    end

    test "has many topics" do
      assert Map.has_key?(@topic_list, :topics)
    end

    test "belongs to a retro" do
      assert Map.has_key?(@topic_list, :retro_id)
    end
  end

  describe "changeset/2" do
    @retro %Retro{}

    test "sets the name" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "Happy", retro: @retro})
      assert changeset.changes.name == "Happy"
    end

    test "sets the retro changeset" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "Happy", retro: @retro})
      assert changeset.changes.retro.action == :insert
      assert changeset.changes.retro.changes == %{}
      assert changeset.changes.retro.valid? == true
    end

    test "returns no errors when attributes are valid" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "Happy", retro: @retro})
      assert changeset.errors == []
    end

    test "returns an error when there is no name" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "", retro: @retro})
      %{name: name_errors} = errors_on(changeset)
      assert ["can't be blank"] == name_errors
    end

    test "returns an error when there is no retro" do
      changeset = TopicList.changeset(%TopicList{}, %{name: "Happy"})
      %{retro: retro_errors} = errors_on(changeset)
      assert ["can't be blank"] == retro_errors
    end
  end
end
