defmodule Memory.Game do

  # Creates a new Game state with a board of size 16 and 0 clicks
  def new do
    %{
      board: gen_board(16),
      clicks: 0
    }
  end

  # Generates a board with the given number of tiles
  def gen_board(size) do
    width = size
            |> :math.sqrt
            |> Float.ceil
            |> trunc
    letters = tile_letters(width * width)
    grid = build_grid(letters, width, [], [])
    Enum.map(grid, fn row -> letters_to_tiles(row) end)
  end

  # Creates a list of tile objects out of a list of letters
  def letters_to_tiles(letters) do
    Enum.map(letters, fn l -> %{letter: l, state: "hidden"} end)
  end
  
  # builds a board from the given letters, accumulating the current row
  # and board, with each row being width letters long
  def build_grid([], _width, row, board) do
    [row | board]
  end

  def build_grid(letters, width, row, board) when length(row) == width do
    build_grid(letters, width, [], [row | board])
  end

  def build_grid([l | rest], width, row, board) do
    build_grid(rest, width, [l | row], board)
  end

  # Creates a random list of tiles with the given number of letters
  def tile_letters(num_letters) do
    gen_char_list(65, div(num_letters + 1, 2), [])
    |> Enum.shuffle
  end

  # Generates a list of characters, starting at the given code point and adding
  # two of each character to the list
  def gen_char_list(_char_code, 0, acc) do 
    acc
    |> to_string
    |> String.graphemes
  end

  def gen_char_list(char_code, num_chars, acc) do
    l = [char_code, char_code | acc]
    gen_char_list(char_code + 1, num_chars - 1, l)  
  end



end
