require_relative 'markers'

class Board
  include Markers

  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7) { empty_circle } }
  end

  def place_token(coloumn, token)
    # Convert user input to array index value
    coloumn -= 1
    row = find_available_row(coloumn)
    grid[row][coloumn] = token
  end

  def game_over?(token)
    game_won?(token) || full?
  end

  private

  attr_writer :grid

  # Find availalbe row and starting from bottom of the grid
  def find_available_row(row = 5, coloumn)
    # Base Case: return row if no token is found in given slot
    return row if grid[row][coloumn] == empty_circle
    return if row.negative?

    # Token detected, move to next slot up
    find_available_row(row - 1, coloumn)
  end

  def full?
    grid.all? do |row|
      row.all? { |column| column == blue_circle || column == yellow_circle }
    end
  end
end
