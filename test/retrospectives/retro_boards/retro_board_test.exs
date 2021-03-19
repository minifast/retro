defmodule Retro.RetroBoards.RetroBoardTest do
  use Retro.DataCase
  alias Retro.RetroBoards.RetroBoard

  describe "schema/2" do
    @retro_board %RetroBoard{}

    test "has a name key" do
      assert Map.has_key?(@retro_board, :name)
    end
  end

  describe "changeset/2" do
    test "sets the name" do
      changeset = RetroBoard.changeset(%RetroBoard{}, %{name: "Happy"})
      assert changeset.changes.name == "Happy"
    end

    test "returns no errors when attributes are valid" do
      changeset = RetroBoard.changeset(%RetroBoard{}, %{name: "Happy"})
      assert changeset.errors == []
    end

    test "returns an error when there is no name" do
      changeset = RetroBoard.changeset(%RetroBoard{}, %{name: ""})
      %{name: name_errors} = errors_on(changeset)
      assert ["can't be blank"] == name_errors
    end
  end
end
