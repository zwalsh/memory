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
    size
    |> tile_letters()
    |> letters_to_tiles(0)
  end

  # Creates a list of tile objects out of a list of letters
  def letters_to_tiles([l | rest_letters], index) do
    first = %{letter: l, state: "hidden", index: index}
    [first | letters_to_tiles(rest_letters, index + 1)]
  end

  def letters_to_tiles([], index) do 
    []
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

  # indicates how many tiles are currently visible on the board
  def visible_count(board) do
    board
    |> Enum.count(&(&1.state == "visible"))
  end

  # returns true if a click at the given index creates a match
  def match?(tiles, index) do
    {:ok, %{letter: clicked_letter}} = Enum.fetch(tiles, index) 
    tiles
    |> Enum.any?(fn tile -> tile.index != index 
    && tile.letter == clicked_letter 
    && tile.state == "visible" end)
  end

  # returns the next board after a click at the given location
  def next_board(board, index) do

  end

  def next_tile(tile, clicked_tile, match?) do
      
  end

  # returns a new game indicating the state after a click
  # at the index
  def tile_clicked(game, index) do
    visible = visible_count(game.board)
    if visible >= 2 do
      game
    end

  end


end
