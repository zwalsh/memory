defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel
  alias Memory.Game
  alias MemoryWeb.GameAgent

  def join("game:" <> name, payload, socket) do
    if authorized?(payload) do
      g = GameAgent.get(name) || Game.new()
      GameAgent.set(name, g)
      socket = socket
               |> assign(:name, name)
      {:ok, %{game: Game.client_view(g)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("click", %{"index" => index}, socket) do
    name = socket.assigns[:name]
    g = GameAgent.get(name)
    if !g do
      {:reply, {:error, "Uninitialized game: " <> name}, socket}
    end
    if Game.visible_count(g.board) >= 2 do
      IO.puts("visible count over 2")
      {:noreply, socket}
    else 
      updated = Game.tile_clicked(g, index)
      if Game.visible_count(updated.board) >= 2 do
        IO.puts("hiding tiles")
        _ = hide_tiles(socket, updated)
      end
      with :ok <- set_game_and_notify(socket, updated) do
        {:noreply, socket}
      else 
        err ->
          {:error, %{message: "Could not broadcast the message", error: err}}
      end
    end
  end

  def handle_in("click", payload, socket) do
    {:reply, 
      {:error, %{message: "Bad click request: missing index field: "}}, 
      socket}
  end

  # Resets the game, creating a new one and storing it on the socket
  def handle_in("reset", _, socket) do
    g = Game.new()
    with :ok <- set_game_and_notify(socket, g) do
      {:noreply, socket}
    else 
      err ->
        {:error, %{message: "Could not broadcast the message", error: err}}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  # schedules a broadcast to the topic with an updated game state
  # that has the visible tiles hidden
  defp hide_tiles(socket, game) do
    hidden = Game.hide_all(game)
    :timer.apply_after(:timer.seconds(1), 
       __MODULE__, 
       :set_game_and_notify,
       [socket, hidden])
  end

  # Broadcasts the new game to all sockets on the given socket's
  # topic, and sets the game on the GameAgent
  def set_game_and_notify(socket, game) do
    GameAgent.set(socket.assigns[:name], game)
    broadcast(socket, "update", %{game: Game.client_view(game)}) 
  end
end
