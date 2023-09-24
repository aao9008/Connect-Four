require_relative '../lib/board'

describe Board do
  let(:yellow_circle) { described_class.new.yellow_circle }
  let(:blue_circle) { described_class.new.blue_circle }
  let(:empty_circle) { described_class.new.empty_circle }
  subject(:board) { described_class.new }

  # These methods belong to the Markers module
  describe '#yellow_circle' do
    context 'when yellow_circle is called' do
      it 'returns a yellow circle' do
        expect(board.yellow_circle).to eq("\e[33m\u25cf\e[0m")
      end
    end
  end

  describe '#blue_circle' do
    context 'when blue_circle is called' do
      it 'returns a blue circle' do
        expect(board.blue_circle).to eq("\e[34m\u25cf\e[0m")
      end
    end
  end

  describe '#empty_circle' do
    context 'when empty_circle is called' do
      it 'returns a empty circle' do
        expect(board.empty_circle).to eq("\u25cb")
      end
    end
  end

  describe '#initialze' do
    matcher :be_empty do
      match { |grid| grid.all? { |rows| rows.all? { |marker| marker == empty_circle } } == true }
    end

    context 'when board is new' do
      it 'has an empty grid' do
        expect(board.grid).to be_empty
      end
    end
  end

  describe '#place_token' do
    context 'when coloumn is empty' do
      it 'places token at bottom most slot' do
        board.place_token(1, blue_circle)
        expect(board.grid[5][0]).to eq(blue_circle)
      end
    end

    context 'when column has 1 slot filled' do
      before do
        grid = board.instance_variable_get(:@grid)
        grid[5][0] = yellow_circle
        board.place_token(1, blue_circle)
      end

      it 'places token in second to last slot from the bottom' do
        expect(board.grid[4][0]).to eq(blue_circle)
      end
    end

    context 'when column has 3 slots filled' do
      before do
        grid = board.instance_variable_get(:@grid)
        grid[5][5] = yellow_circle; grid[4][5] = blue_circle; grid[3][5] = yellow_circle
        board.place_token(6, blue_circle)
      end

      it 'places token at third slot from the top' do
        expect(board.grid[2][5]).to eq(blue_circle)
      end
    end
  end

  describe '#game_over?' do 
    context 'when board is empty' do
      it 'is not game over' do
        expect(board.game_over?('⚫')).not_to be_game_over
      end
    end

    context 'when there is a horizontal win' do
      before do
        board.instance_variable_set(:@grid, 
         [[nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['⚪', nil, nil, nil, nil, nil, nil],
          ['⚫', nil, nil, nil, nil, nil, nil],
          ['⚪', '⚫', nil, nil, nil, nil, nil],
          ['⚪', '⚫', '⚫', '⚫', '⚫', nil, nil]])
      end

      it 'is game over' do
        expect(board.game_over?('⚫')).to be_game_over
      end
    end

    context 'when there is a vertical win' do
      before do
        board.instance_variable_set(:@grid, 
         [[nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['⚪', nil, nil, nil, nil, '⚪', nil],
          ['⚫', nil, nil, nil, nil, '⚪', nil],
          ['⚪', '⚫', nil, nil, nil, '⚪', nil],
          ['⚪', '⚫', '⚫', nil, nil, '⚪', nil]])
      end

      it 'is game over' do
        expect(board.game_over?('⚪')).to be true
      end
    end

    context 'when there is a diagonal win' do
      before do
        board.instance_variable_set(:@grid, 
         [[nil, '⚫', nil, nil, nil, nil, nil],
          ['⚫', nil, '⚫', nil, nil, nil, nil],
          ['⚪', '⚫', nil, '⚫', nil, nil, nil],
          ['⚫', nil, '⚫', nil, '⚫', nil, nil],
          [nil, '⚫', nil, '⚫', nil, nil, nil],
          ['⚪', '⚫', '⚪', nil, '⚪', nil, nil]])
      end

      it 'is game over' do
        expect(board.game_over?('⚫')).to be true
      end
    end

    context 'when board is full' do
      before do
        board.instance_variable_set(:@grid, 
         [['⚪', '⚫', '⚫', '⚫', '⚫', '⚫', '⚫'],
          ['⚫', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
          ['⚪', '⚫', '⚫', '⚫', '⚫', '⚫', '⚫'],
          ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
          ['⚫', '⚫', '⚫', '⚫', '⚫', '⚫', '⚫'],
          ['⚪', '⚫', '⚪', '⚪', '⚪', '⚪', '⚪']])
      end

      it 'is game over' do
        expect(board.game_over?('⚫')).to be true
      end
    end
  end
end
