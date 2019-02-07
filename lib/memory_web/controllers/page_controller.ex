defmodule MemoryWeb.PageController do
  use MemoryWeb, :controller

  def index(conn, params) do
    game = params["game"]
    if game do
      render conn, "game.html", game: game
    else
      render conn, "index.html"
    end
  end
end
