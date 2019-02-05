defmodule Memory.GameTest do
  use ExUnit.Case 

  test "gen char list" do
    assert Memory.Game.gen_char_list(65, 1, []) == ["A", "A"]
    assert Memory.Game.gen_char_list(65, 3, []) == ["C", "C", "B", "B", "A", "A"]
    assert Memory.Game.gen_char_list(68, 1, []) == ["D", "D"]
    assert Memory.Game.gen_char_list(65, 1, [64]) == ["A", "A", "@"]
  end

  test "build board" do
    board = Memory.Game.gen_board(16)
    assert length(board) == 16
    [tile | _tiles] = board
    %{letter: _, state: s, index: i} = tile
    assert s == "hidden"
    assert i == 0
  end

  test "visible count" do
    board = Memory.Game.gen_board(16)
    assert Memory.Game.visible_count(board) == 0
    board = [%{:letter => "A", :state => "visible"},
      %{:letter => "A", :state => "visible"}, 
      %{:letter => "A", :state => "visible"},
      %{:letter => "A", :state => "hidden"}]
    assert Memory.Game.visible_count(board) == 3
  end

  test "match?" do
    board = [%{letter: "A", state: "visible", index: 0},
      %{letter: "A", state: "hidden", index: 1},
      %{letter: "B", state: "visible", index: 2}]
    assert !Memory.Game.match?(board, 0)
    assert Memory.Game.match?(board, 1) 
    assert !Memory.Game.match?(board, 2)
  end
end
