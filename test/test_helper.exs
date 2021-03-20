Application.put_env(:wallaby, :base_url, RetrospectivesWeb.Endpoint.url())
Ecto.Adapters.SQL.Sandbox.mode(Retrospectives.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start()
