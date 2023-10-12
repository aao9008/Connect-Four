require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { double(Player, name: 'Judy', symbol: 'x') }
  let(:board) { double(Board) }

  describe '#create_player' do
    context 'when creating player 1' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('Judy')
        allow(game).to receive(:yellow_circle).and_return("\e[33m\u25cf\e[0m")
      end

      it 'creates player 1 with the right parameters' do
        expect(Player).to receive(:new).with('Judy', "\e[33m\u25cf\e[0m")
        game.create_player(1)
      end
    end

    context 'when creating player 2' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('Chichi')
        allow(game).to receive(:blue_circle).and_return("\e[34m\u25cf\e[0m")
      end

      it 'creates player 2 with the right parameters' do
        expect(Player).to receive(:new).with('Chichi', "\e[34m\u25cf\e[0m")
        game.create_player(2)
      end
    end
  end

  describe '#solicit_move' do
    context 'when given a valid move' do
      before do
        allow(game).to receive(:gets).and_return("4\n")
      end

      it 'stops loop and does not display error message' do
        error_message = 'Invalid move, please select an empty column between 1 and 7!'

        expect(game).to_not receive(:puts).with(error_message)
        game.solicit_move
      end
    end

    context 'when given an invalid move once then a valid move' do
      before do
        allow(game).to receive(:gets).and_return("10\n", "1\n")
      end

      it 'completes loop and displays error message once' do
        error_message = 'Invalid move, please select an empty column between 1 and 7!'

        expect(game).to receive(:puts).with(error_message).once
        game.solicit_move
      end
    end

    context 'when given and invalid move twice then a valid move' do
      before do
        allow(game).to receive(:gets).and_return("a\n", "17\n", "7\n")
      end

      it 'completes loops and displays error message twice' do
        error_message = 'Invalid move, please select an empty column between 1 and 7!'

        expect(game).to receive(:puts).with(error_message).twice
        game.solicit_move
      end
    end
  end

  describe '#play_round' do
    before do
      allow(game).to receive(:prompt_player)
      allow(game).to receive(:current_player).and_return(player1)
      allow(game).to receive(:solicit_move).and_return (6)
    end

    it 'sends #place_token to board' do
      allow(game.board).to receive(:display)
      expect(game.board).to receive(:place_token).with(6, 'x')
      game.play_round
    end

    it 'sends #display to baord' do
      expect(game.board).to receive(:display)
      game.play_round
    end
  end

  describe '#play_game' do
    context ' when #board.game_over? is false four times' do
      before do
        allow(game).to receive(:setup)
        allow(game).to receive(:current_player).and_return(player1)
        allow(game.board).to receive(:game_over?).with(player1.symbol).and_return(false, false, false, false, true)
      end

      it 'calls #switch_turns four times' do
        allow(game).to receive(:play_round)
        expect(game).to receive(:switch_turns).exactly(4).times
        game.play_game
      end

      it 'calls #play_round four times' do
        expect(game).to receive(:play_round).exactly(4).times
        game.play_game
      end

      it 'call #conclusion once' do
        allow(game).to receive(:play_round)
        expect(game).to receive(:conclusion).once
        game.play_game
      end
    end
  end
end
