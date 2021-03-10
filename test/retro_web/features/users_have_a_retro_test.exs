defmodule RetroWeb.UsersHaveARetro do
  use RetroWeb.FeatureCase

  feature "users have a retro", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.text("Welcome to Retro!"))
  end
end
