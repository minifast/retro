defmodule RetrospectivesWeb.FeatureCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case, async: false
      use Wallaby.Feature
      import Wallaby.Query
      alias Retrospectives.Repo
    end
  end
end
