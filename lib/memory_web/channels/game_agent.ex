defmodule MemoryWeb.GameAgent do
  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(name) do
    Agent.get(__MODULE__, fn map -> map[name] end)
  end

  def set(name, game) do
    Agent.update(__MODULE__, fn map -> Map.put(map, name, game) end)
  end

end

