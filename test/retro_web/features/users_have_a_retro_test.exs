defmodule RetroWeb.UsersHaveARetro do
  use RetroWeb.FeatureCase

  @sessions 2
  feature "users have a retro", %{sessions: [session, other_session]} do
    session
    |> visit("/")
    |> assert_has(Query.text("Welcome to Retro!"))
    |> fill_in(text_field("topic[description]"), with: "the bagels were incredible!")
    |> click(button("Save"))
    |> assert_has(Query.text("the bagels were incredible!"))

    other_session
    |> visit("/")
    |> assert_has(Query.text("Welcome to Retro!"))
    |> assert_has(Query.text("the bagels were incredible!"))
    |> fill_in(text_field("topic[description]"), with: "as were the donuts!")
    |> click(button("Save"))
    |> assert_has(Query.text("as were the donuts!"))

    session
    |> assert_has(Query.text("as were the donuts!"))
  end
end
