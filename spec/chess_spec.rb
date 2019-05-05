require './lib/state.rb'
require './lib/game.rb'

describe State do

    def starting_board
        board = State.new(squares=[
                ["BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"],
                ["BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"],
                ["WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"]]) 
        return board
    end

    def castling_board
        board = State.new(squares=[
                ["BR",  nil,  nil,  nil, "BK",  nil,  nil, "BR"],
                ["BP", "BP", "BP", "BP", "BP",  nil, "BP", "BP"],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil, "WQ",  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"],
                ["WR", "WN",  nil,  nil, "WK",  nil,  nil, "WR"]]) 
        return board
    end

    def sample_board
        board = State.new(squares=[
                [ nil,  nil,  nil, "BQ",  nil,  nil,  nil,  nil],
                [ nil, "BN",  nil,  nil,  nil, "BP", "BK",  nil],
                ["WP", "WN", "BP",  nil,  nil, "WP",  nil,  nil],
                ["WK",  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["BB",  nil,  nil,  nil,  nil,  nil, "BR",  nil],
                [ nil, "WP",  nil,  nil,  nil,  nil,  nil, "WR"],
                [ nil,  nil, "WP",  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil, "WB"]]) 
        return board
    end

    def check_board
        board = State.new(squares=[
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil, "WK",  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["BK",  nil, "BR",  nil, "WR", "BP", "WP", "BP"],
                ["WB",  nil,  nil,  nil,  nil,  nil, "BB",  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil]]) 
        return board
    end

    describe "#locate_king" do
        it "returns the king's square" do
            board = sample_board
            expect(board.locate_king("W")).to eql([3,0])
        end
    end

    describe "#can_go?" do
        it "allows pawn to move forward one" do
            board = sample_board
            expect(board.can_go?([6,2], [5,2])).to be true
        end

        it "does not allow pawn to move backward" do
            board = sample_board
            expect(board.can_go?([6,2], [7,2])).to be false
        end

        it "allows pawn to move forward two from starting square" do
            board = sample_board
            expect(board.can_go?([6,2], [4,2])).to be true
        end

        it "does not allow pawn to move forward to from elsewhere" do
            board = sample_board
            expect(board.can_go?([5,1], [3,1])).to be false
        end

        it "does not allow pawn to move sideways" do
            board = sample_board
            expect(board.can_go?([6,2], [5,3])).to be false
        end

        it "allows knight to move correctly" do
            board = sample_board
            expect(board.can_go?([1,1], [3,0])).to be true
        end

        it "does not allow knight to move incorrectly" do
            board = sample_board
            expect(board.can_go?([1,1], [3,1])).to be false
        end
        
        it "allows bishop to move correctly" do
            board = sample_board
            expect(board.can_go?([7,7], [3,3])).to be true
        end
        
        it "does not allow bishop to move incorrectly" do
            board = sample_board
            expect(board.can_go?([7,7], [3,1])).to be false
        end

        it "does not allow bishop to jump" do
            board = sample_board
            expect(board.can_go?([7,7], [1,1])).to be false
        end

        it "allows rook to move correctly" do
            board = sample_board
            expect(board.can_go?([5,7], [5,4])).to be true
        end
        
        it "does not allow rook to move incorrectly" do
            board = sample_board
            expect(board.can_go?([5,7], [6,6])).to be false
        end

        it "does not allow rook to jump" do
            board = sample_board
            expect(board.can_go?([5,7], [5,0])).to be false
        end

        it "allows queen to move straight" do
            board = sample_board
            expect(board.can_go?([0,3], [0,7])).to be true
        end

        it "allows queen to move diagonally" do
            board = sample_board
            expect(board.can_go?([0,3], [2,5])).to be true
        end
        
        it "does not allow queen to move incorrectly" do
            board = sample_board
            expect(board.can_go?([0,3], [2,4])).to be false
        end

        it "does not allow queen to jump" do
            board = sample_board
            expect(board.can_go?([0,3], [3,6])).to be false
        end

        it "allows king to move one space" do
            board = sample_board
            expect(board.can_go?([1,6], [2,6])).to be true
        end
        
        it "does not allow king to move two spaces" do
            board = sample_board
            expect(board.can_go?([1,6], [3,6])).to be false
        end

        it "allows pawn to capture diagonally" do
            board = sample_board
            expect(board.can_go?([2,5], [1,6])).to be true
        end
        
        it "does not allow pawn to capture straight" do
            board = sample_board
            expect(board.can_go?([2,5], [1,5])).to be false
        end

        it "does not allow pawn to capture own piece" do
            board = sample_board
            expect(board.can_go?([6,2], [5,1])).to be false
        end

        it "does not allow piece to capture own piece" do
            board = sample_board
            expect(board.can_go?([5,7], [5,1])).to be false
        end

        it "allows king side castling" do
            board = castling_board
            expect(board.can_go?([7,4], [7,6])).to be true
        end

        it "allows queen side castling" do
            board = castling_board
            expect(board.can_go?([0,4], [0,2])).to be true
        end

        it "moves rook when castling" do
            board = castling_board
            board.make_move([[0,4], [0,2]])
            expect(board.squares[0][3]).to eql("BR")
        end

        it "does not allow castling through check" do
            board = castling_board
            expect(board.can_go?([0,4], [0,6])).to be false
        end

        it "does not allow castling through obstructing pieces" do
            board = castling_board
            expect(board.can_go?([7,4], [7,2])).to be false
        end
    end

    def sample_board2
        board = State.new(squares=[
                [ nil,  nil,  nil, "BQ",  nil,  nil,  nil,  nil],
                [ nil, "BN",  nil,  nil,  nil, "BP", "BK",  nil],
                ["WN", "WN", "BP",  nil,  nil,  nil,  nil,  nil],
                ["WK",  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["BB",  nil,  nil,  nil,  nil,  nil, "BR",  nil],
                [ nil, "WP",  nil,  nil,  nil,  nil,  nil, "WR"],
                [ nil,  nil, "WP",  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil, "WB"]]) 
        return board
    end

    def sample_board3
        board = State.new(squares=[
                [ nil,  nil,  nil, "BQ",  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil, "BK",  nil],
                ["BB", "BR", "BP",  nil,  nil,  nil,  nil,  nil],
                ["WK",  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["WP",  nil,  nil,  nil,  nil,  nil, "BR",  nil],
                [ nil,  nil, "BP",  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil, "WP",  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil]]) 
        return board
    end

    describe "#check?" do
        it "identifies check" do
            board = sample_board
            expect(board.check?("B")).to be true
        end

        it "identifies no check" do
            board = sample_board2
            expect(board.check?("B")).to be false
        end
    end

    describe "#get_all_legals" do
        it "returns all legal moves for player" do
            board = sample_board2
            expect(board.get_all_legals("B")).to be_instance_of Array
            #puts the array for this test to actually be meaningful!
        end
    end

    describe "#make_move" do
        it "shows piece at new location" do
            board = sample_board2
            board.make_move([[5,1],[4,0]])
            expect(board.squares[4][0]).to eql("WP")
        end

        it "no longer shows piece at old location" do
            board = sample_board2
            board.make_move([[5,1],[4,0]])
            expect(board.squares[5][1]).to eql(nil)
        end
    end

    describe "#checkmate?" do
        it "identifies checkmate" do
            board = sample_board2
            expect(board.mate?("W")).to be true
        end

        it "does not identify checkmate when capture would escape" do
            board = sample_board
            expect(board.mate?("W")).to be false
        end

        it "does not identify checkmate when only in check" do
            board = sample_board
            expect(board.mate?("B")).to be false
        end

        it "identifies stalemate" do
            board = sample_board3
            expect(board.mate?("W")).to be true
        end
    end
end

describe Game do
    def check_board
        game = Game.new
        game.board = State.new([
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil, "WK",  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["BK",  nil, "BR",  nil, "WR", "BP", "WP", "BP"],
                ["WB",  nil,  nil,  nil,  nil,  nil, "BB",  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil]])
        return game
    end
      
    describe "#legal_move?" do
        it "allows a legal move" do
            game = check_board
            game.current_player = "B"
            expect(game.legal_move?("h5-h4")).to be true
        end

        it "does not allow an illegal move" do
            game = check_board
            expect(game.legal_move?("a4-a5")).to be false
        end

        it "does not allow moving into check" do
            game = check_board
            game.current_player = "B"
            expect(game.legal_move?("a5-b5")).to be false
        end

        it "does not allow discovering check on self" do
            game = check_board
            game.current_player = "B"
            expect(game.legal_move?("c5-h5")).to be false
        end

        it "allows en passant capture" do #assuming just moved, not tested
            game = check_board
            expect(game.legal_move?("g5-h6")).to be true
        end

        it "removes pawn captured en passant" do
            game = check_board
            game.board.make_move([[3,6],[2,7]])
            expect(game.board.squares[3][7]).to be nil
        end

        it "does not allow en passant capture to reveal check" do
            game = check_board
            expect(game.legal_move?("g5-f6")).to be false
        end

    end
end
