defmodule RetrospectivesWeb.UsersHaveARetro do
  use RetrospectivesWeb.FeatureCase

  alias Retrospectives.Retros

  @sessions 2
  feature "users have a retro", %{sessions: [session, other_session]} do
    session
    |> visit("/retros")

    other_session
    |> visit("/retros")

    session
    |> click(link("Add Retro"))
    |> assert_has(css("article.retro"))

    refute Wallaby.Browser.current_url(session) == "http://localhost:4002/retros"
    retro = List.last(Retros.list_retros())
    assert Wallaby.Browser.current_url(session) == "http://localhost:4002/retros/#{retro.id}"

    session
    |> assert_has(Query.text("Retro #{retro.id}"))

    other_session
    |> click(link("Retro #{retro.id}"))
    |> assert_has(Query.text("Retro #{retro.id}"))

    session
    |> fill_in(text_field("topic_list[name]"), with: "happy stuff")
    |> click(button("Add List"))
    |> assert_has(Query.text("happy stuff"))

    other_session
    |> assert_has(Query.text("happy stuff"))
    |> fill_in(text_field("topic[description]"), with: "I really liked those bagels")
    |> click(button("Add Topic"))
    |> assert_has(Query.text("I really liked those bagels"))

    session
    |> assert_has(Query.text("I really liked those bagels"))
    |> click(link("Delete Topic"))
    |> refute_has(Query.text("I really liked those bagels"))

    other_session
    |> refute_has(Query.text("I really liked those bagels"))
    |> click(link("Delete List"))
    |> refute_has(Query.text("happy stuff"))

    session
    |> refute_has(Query.text("happy stuff"))
  end
end
