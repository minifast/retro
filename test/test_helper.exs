Application.put_env(:wallaby, :base_url, RetroWeb.Endpoint.url())
Ecto.Adapters.SQL.Sandbox.mode(Retro.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start()
