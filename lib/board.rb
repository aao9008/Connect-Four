require_relative 'markers'

# Class to handle game board logic
class Board
  include Markers

  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7) { empty_circle } }
  end

  # Function places player token in given column
  def place_token(column, token)
    # Convert user input to array index value
    column -= 1
    # Find bottom most empty slot
    row = find_available_row(column)
    # Place toekn in slot
    grid[row][column] = token
  end

  def game_over?(token)
    game_won?(token) || full?
  end

  private

  attr_writer :grid

  # Find availalbe row and starting from bottom of the grid
  def find_available_row(row = 5, column)
    # Base Case: return row if no token is found in given slot
    return row if grid[row][column] == empty_circle
    return if row.negative?

    # Token detected, move to next slot up
    find_available_row(row - 1, column)
  end

  # Check if board has any empty slots left, function returns true or false
  def full?
    # Check all rows in the board
    grid.all? do |row|
      # Check each column/slot in each row for a player token
      row.all? { |column| column != empty_circle }
    end
  end

  # Has a player won the game
  def game_won?(token)
    # Check for horizontal win, or veritcal win, or diagonal win
    horizontal_win?(token) || vertical_win?(token) || diagonal_win?(token)
  end

  # Look for a horizontal 4 in a row
  def horizontal_win?(token)
    # Look at each row
    grid.each do |row|
      # Iterate over 4 slots in a given row
      row.each_cons(4) do |four_slots|
        # If all 4 slots are the same player token, there is 4 in a row and return true
        return true if four_slots.all? { |slot| slot == token }
      end
    end

    false
  end

  # Look for a vertical 4 in a row
  def vertical_win?(token, column = 0, rows = [0, 1, 2, 3])
    # Exit function once column 7 is reached.
    return false if column == 7

    # Check the tokens in a column for the given set of rows
    return true if rows.all? { |row| grid[row][column] == token }

    # Shift set of rows by one.
    rows.map! { |row| row += 1 }

    # Set of rows exceeds game board size, move on to the next column
    if rows == [3, 4, 5, 6]
      vertical_win?(token, column + 1)
    # Edge of board not reached, move on to next set of 4 rows.
    else
      vertical_win?(token, column, rows)
    end
  end

  # Check for a diagonal win
  def diagonal_win?(token)
    # Create list of right and left diagonals
    diagonals = create_diagonals

    # Check if any diagonal in the list
    diagonals.any? do |diagonal|
      # Has the same token in all slots
      diagonal.all? do |coords|
        grid[coords[0]][coords[1]] == token
      end
    end
  end

  # Create list of diagonal cooridinates
  def create_diagonals
    # List of diagonals will contain lists of diagonals
    # Each diagonal will be a list of coordinates
    diagonals = []

    # Iterate over each row
    grid.each_with_index do |row, row_idx|
      # In each row iterate over each column
      row.each_index do |col_idx|
        # Add the list of coordinates for a diagonal to the diagonals list
        diagonals << right_diagonal([[row_idx, col_idx]])
        diagonals << left_diagonal([[row_idx, col_idx]])
      end
    end

    # Remove nil values from list
    diagonals.compact
  end

  # Creat list of right diagonals
  def right_diagonal(diagonal)
    # Diagonals that orginate on row 3 or column 3 are incapable of having a diagonal length of 4
    # Return nil for diagnols that will not have a lenght of 4
    return if diagonal[-1][0] > 2 || diagonal[-1][1] > 3

    # Get coordinates of the next 3 slots in the diagonal
    3.times do
      diagonal << [diagonal[-1][0] + 1, diagonal[-1][1] + 1]
    end

    # Return list of all slot coordinates in the diagonal
    diagonal
  end

  # Creat list of left diagonals
  def left_diagonal(diagonal)
    # Diagonals that orginate on row 3 or before column 3 are incapable of having a diagonal length of 4.
    # Return nil for diagnols that will not have a lenght of 4
    return if diagonal[-1][0] > 2 || diagonal[-1][1] < 3

    # Get coordinate of the next 3 slots in the diagonal
    3.times do
      diagonal << [diagonal[-1][0] + 1, diagonal[-1][1] - 1]
    end

    # Return list of all slot coordinates in the diagonal
    diagonal
  end
end
