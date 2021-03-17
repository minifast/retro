defmodule RetroWeb.Test.LiveComponentHarness do
  @moduledoc false
  use RetroWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    assigns = session["component_assigns"] |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    socket =
      socket
      |> assign(:component, session["component"])
      |> assign(:component_assigns, assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
    <%= live_component @socket, :"#{@component}", @component_assigns %>
    </div>
    """
  end
end
