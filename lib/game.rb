require_relative 'markers'
require_relative 'board'
require_relative 'player'

# This class handles game loop logic
class Game
  include Markers # Include Markers module

  attr_reader :player_markers, :player1, :player2, :current_player, :board

  def initialize
    @board = Board.new
    @player_markers = [yellow_circle, blue_circle]
  end

  def setup
    # Intro Message
    intro_message

    # Create players
    @player1 = create_player(1)
    @player2 = create_player(2)

    display_player_tokens

    randomize_first_turn
  end

  def intro_message
    puts <<~INTRO

    Let's play Connect Four!

    The first player to connect 4 pieces consecutively (horizontally, vertically or diagonally) wins.

    To place a piece, enter a column number (1 to 7).

    INTRO
  end

  def display_player_tokens
    puts "\n#{player1.name} your marker is #{player1.symbol}."
    puts "#{player2.name} your marker is #{player2.symbol}.\n\n"
  end

  def create_player(number)
    # Get player name
    puts "\nPlayer #{number}, enter your name:"
    name = gets.chomp.capitalize

    # Get player marker
    marker = player_markers[number - 1]

    # Create player object
    player = Player.new(name, marker)
  end

  # Randomly pick player during game setup
  def randomize_first_turn
    @current_player = [player1, player2].sample
  end

  def play_game
    setup

    board.display

    # Play rounds until game is over
    until board.game_over?(current_player.symbol) do
      # Switch players
      @current_player = switch_turns

      # Play round
      play_round
    end

    # End game
    conclusion
  end

  def play_round
    prompt_player
    move = solicit_move
    board.place_token(move, current_player.symbol)
    system 'clear'
    board.display
  end

  # Change current player
  def switch_turns
    current_player == player1 ? player2 : player1
  end

  def prompt_player
    puts "\n#{current_player.name}, make your move:"
  end

  # Get user input
  def solicit_move
    loop do
      move = gets.chomp
      return move.to_i if valid_move?(move)

      puts 'Invalid move, please select an empty column between 1 and 7!'
    end
  end

  # Verfiy player input
  def valid_move?(move)
    # Input is single diget between 1 & 7
    # Column on grid is not full
    move.match(/^[1-7]$/) && board.grid[0][move.to_i - 1] == empty_circle
  end

  # Display end game message
  def conclusion
    puts "#{current_player.name} has won!" if board.game_won?(current_player.symbol)

    puts "It's a tie!" if board.full?
  end
end
