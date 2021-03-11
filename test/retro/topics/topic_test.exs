defmodule Retro.Topics.TopicTest do
  use Retro.DataCase
  alias Retro.Topics.Topic

  describe "schema/2" do
    @topic %Topic{}

    test "has a description key" do
      assert Map.has_key?(@topic, :description)
    end
  end

  describe "changeset/2" do
    test "sets the description" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy"})
      assert changeset.changes.description == "Happy"
    end

    test "returns no errors when attributes are valid" do
      changeset = Topic.changeset(%Topic{}, %{description: "Happy"})
      assert changeset.errors == []
    end

    test "returns an error when there is no description" do
      changeset = Topic.changeset(%Topic{}, %{description: ""})
      %{description: description_errors} = errors_on(changeset)
      assert ["can't be blank"] == description_errors
    end
  end
end
