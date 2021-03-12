defmodule RetroWeb.UsersHaveRetroBoards do
  use RetroWeb.FeatureCase

  @sessions 2
  feature "users have retro boards", %{sessions: [session, other_session]} do
    session
    |> visit("/retro_boards")
    |> assert_has(Query.text("Retro Boards"))
    |> fill_in(text_field("retro_board[name]"), with: "Bagels!")
    |> click(button("Add"))
    |> assert_has(Query.text("Bagels!"))

    other_session
    |> visit("/retro_boards")
    |> assert_has(Query.text("Retro Boards"))
    |> assert_has(Query.text("Bagels!"))
    |> click(Query.link("Edit"))
    |> find(Query.css("#add-retro-board-form"), fn form ->
      form
      |> fill_in(text_field("retro_board[name]"), with: "Bagels")
    end)
    |> click(button("Save"))
    |> assert_has(Query.text("Bagels"))

    other_session
    |> fill_in(text_field("retro_board[name]"), with: "Donuts")
    |> click(button("Add"))
    |> assert_has(Query.text("Donuts"))

    session
    |> assert_has(Query.text("Bagels"))
    |> accept_confirm(fn s ->
      click(s, Query.link("Delete", count: 2, at: 0))
    end)

    session
    |> assert_has(Query.text("Donuts"))
    |> refute_has(Query.text("Bagels"))

    other_session
    |> assert_has(Query.text("Donuts"))
    |> refute_has(Query.text("Bagels"))

    session
    |> click(Query.link("Donuts"))
    |> assert_has(css("h1", text: "Donuts"))

    session
    |> click(Query.link("Edit"))
    |> find(Query.css("#retro-board-form"), fn form ->
      form
      |> fill_in(text_field("retro_board[name]"), with: "My Donuts")
    end)
    |> click(button("Save"))
    |> assert_has(Query.text("My Donuts"))

    session
    |> click(Query.link("Back"))
    |> assert_has(Query.text("Retro Boards"))
  end
end
