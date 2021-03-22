defmodule RetrospectivesWeb.UsersHaveARetro do
  use RetrospectivesWeb.FeatureCase

  @sessions 2
  feature "users have a retro", %{sessions: [session, other_session]} do
    other_session
    |> visit("/")

    session
    |> visit("/")
    |> fill_in(text_field("topic_list[name]"), with: "happy stuff")
    |> click(button("Add List"))

    other_session
    |> assert_has(Query.text("happy stuff"))

    session
    |> fill_in(text_field("topic[description]"), with: "the bagels were incredible!")
    |> click(button("Add Topic"))
    |> assert_has(Query.text("the bagels were incredible!"))

    other_session
    |> assert_has(Query.text("the bagels were incredible!"))
    |> fill_in(text_field("topic[description]"), with: "as were the donuts!")
    |> click(button("Add Topic"))
    |> assert_has(Query.text("as were the donuts!"))

    session
    |> assert_has(Query.text("as were the donuts!"))
    |> accept_confirm(fn s ->
      click(s, Query.link("Delete Topic", count: 2, at: 1))
    end)

    session
    |> assert_has(Query.text("as were the donuts!"))
    |> refute_has(Query.text("the bagels were incredible!"))

    other_session
    |> assert_has(Query.text("as were the donuts!"))
    |> refute_has(Query.text("the bagels were incredible!"))
    |> accept_confirm(fn s ->
      click(s, Query.link("Delete List"))
    end)

    other_session
    |> refute_has(Query.text("happy stuff"))
    |> refute_has(Query.text("as were the donuts!"))

    session
    |> refute_has(Query.text("happy stuff"))
    |> refute_has(Query.text("as were the donuts!"))
  end
end
