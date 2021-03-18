defmodule RetroWeb.UsersHaveARetro do
  use RetroWeb.FeatureCase

  @sessions 2
  feature "users have a retro", %{sessions: [session, other_session]} do
    session
    |> visit("/")
    |> fill_in(text_field("topic[description]"), with: "the bagels were incredible!")
    |> click(button("Save"))
    |> assert_has(Query.text("the bagels were incredible!"))

    other_session
    |> visit("/")
    |> assert_has(Query.text("the bagels were incredible!"))
    |> fill_in(text_field("topic[description]"), with: "as were the donuts!")
    |> click(button("Save"))
    |> assert_has(Query.text("as were the donuts!"))

    session
    |> assert_has(Query.text("as were the donuts!"))
    |> accept_confirm(fn s ->
      click(s, Query.link("Delete", count: 2, at: 1))
    end)

    session
    |> assert_has(Query.text("as were the donuts!"))
    |> refute_has(Query.text("the bagels were incredible!"))

    other_session
    |> assert_has(Query.text("as were the donuts!"))
    |> refute_has(Query.text("the bagels were incredible!"))
  end
end
