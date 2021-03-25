defmodule RetrospectivesWeb.RetrosLive.Index do
  @moduledoc false

  use RetrospectivesWeb, :live_view

  alias Retrospectives.Retros

  @impl true
  def mount(_parms, _session, socket) do
    if connected?(socket), do: Retros.subscribe_to_retros()

    retros = Retros.list_retros()

    {:ok, assign(socket, :retros, retros)}
  end

  @impl true
  def handle_info({:retro_created, _retros}, socket) do
    {:noreply, assign(socket, :retros, Retros.list_retros())}
  end

  @impl true
  def handle_event("add_retro", _params, socket) do
    case Retros.create_retro() do
      {:ok, retro} ->
        {:noreply, push_redirect(socket, to: "/retros/#{retro.id}")}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end
end
