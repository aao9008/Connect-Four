require_relative 'markers'

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
    horizontal_win?(token)
  end

  def horizontal_win?(token)
    grid.each do |row|
      row.each_cons(4) do |four_slots|
        return true if four_slots.all? { |slot| slot == token }
      end
    end
  end
end
