require './lib/state.rb'

describe State do
    describe "#locate_king" do
        it "should return king's square" do
            board = State.new(squares=[
                ["BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"],
                ["BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                ["WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"],
                ["WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"]])
            expect(board.locate_king("W")).to eql([7,4])
        end

    end



end
