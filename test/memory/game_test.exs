defmodule Memory.GameTest do
  use ExUnit.Case 

  test "gen char list" do
    assert Memory.Game.gen_char_list(65, 1, []) == ["A", "A"]
    assert Memory.Game.gen_char_list(65, 3, []) == ["C", "C", "B", "B", "A", "A"]
    assert Memory.Game.gen_char_list(68, 1, []) == ["D", "D"]
    assert Memory.Game.gen_char_list(65, 1, [64]) == ["A", "A", "@"]
  end

  test "build board" do
    assert length(Memory.Game.gen_board(16)) == 4
    [row | _rest] = Memory.Game.gen_board(36)
    assert length(row) == 6
    [tile | _tiles] = row
    %{letter: _, state: s} = tile
    assert s == "hidden"
  end
end
