defmodule RetroWeb.FeatureCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case, async: false
      use Wallaby.Feature
      import Wallaby.Query
      alias Retro.Repo
    end
  end
end
