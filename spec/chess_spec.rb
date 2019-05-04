require './lib/state.rb'

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
        
    end

    def sample_board2
        board = State.new(squares=[
                [ nil,  nil,  nil, "BQ",  nil,  nil,  nil,  nil],
                [ nil, "BN",  nil,  nil,  nil, "BP", "BK",  nil],
                ["WP", "WN", "BP",  nil,  nil,  nil,  nil,  nil],
                ["WK",  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["BB",  nil,  nil,  nil,  nil,  nil, "BR",  nil],
                [ nil, "WP",  nil,  nil,  nil,  nil,  nil, "WR"],
                [ nil,  nil, "WP",  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil, "WB"]]) 
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

end
