defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel
  alias Memory.Game

  def join("game:" <> name, payload, socket) do
    if authorized?(payload) do
      g = Game.new()
      socket = socket
               |> assign(:game, g)
               |> assign(:name, name)
      {:ok, %{game: Game.client_view(g)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("click", %{index: index}, socket) do
    g = socket.assigns[:game]
    updated = Game.tile_clicked(g, index)
    socket = socket
             |> assign(:game, updated)
    view = Game.client_view(updated)
    {:reply, {:ok, %{game: view}}, socket}
  end

  def handle_in("click", _, socket) do
    {:reply, 
      {:error, %{message: "Bad click request: missing index field"}}, 
      socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
