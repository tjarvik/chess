class Board
    def initialize
        @pieces = {}
        @locations = []
        make_pieces("W")
        make_pieces("B")
    end
    
    def make_pieces(color)
        row = color == "W" ? 0 : 7
        @pieces["#{color}K".to_sym] = King.new
        @locations[4][row] = @pieces["#{color}K".to_sym]
        @pieces["#{color}Q".to_sym] = Queen.new
        @locations[3][row] = @pieces["#{color}Q".to_sym]
        @pieces["#{color}R1".to_sym] = Rook.new
        @locations[0][row] = @pieces["#{color}R1".to_sym]
        @pieces["#{color}R2".to_sym] = Rook.new
        @locations[7][row] = @pieces["#{color}R2".to_sym]
        @pieces["#{color}B1".to_sym] = Bishop.new
        @locations[2][row] = @pieces["#{color}B1".to_sym]
        @pieces["#{color}B2".to_sym] = Bishop.new
        @locations[5][row] = @pieces["#{color}B2".to_sym]
        @pieces["#{color}N1".to_sym] = Knight.new
        @locations[1][row] = @pieces["#{color}N1".to_sym]
        @pieces["#{color}N2".to_sym] = Knight.new
        @locations[6][row] = @pieces["#{color}N2".to_sym]
        row = color == "W" ? 1 : 6
        8.times do |i|
            @pieces["#{color}P#{i+1}".to_sym] = Pawn.new
            @locations[i][row] = @pieces["#{color}P#{i+1}".to_sym]
        end
    end


    def display
        8.times do |row|
            #number header left
            8.times do |column|

            end
        end
        #letter footer
    end
end

class Piece
    attr_accessor :id
    attr_accessor :color
    attr_accessor :location

    def initialize(id, color, location)

    end

end

class Pawn < Piece
end

class Knight < Piece
end

class Bishop < Piece
end

class Rook < Piece
end

class Queen < Piece
end

class King < Piece

    def in_check?

    end

    def in_checkmate?

    end
end


class Player
    attr_accessor :name

    def initialize(name)
        @name = name
    end

end



class Game
    def initialize
        @@checkmate = false
        @white = Player.new(white)
        @black = Player.new(black)
        @board = Board.new
        @current_player = @white
    end

    def play
        take_turn until @@checkmate
    end

    def take_turn
        @board.display
        prompt_move
        #update piece locations
        #checkmate?
        toggle_player
    end

    def prompt_move
        #display whose turn
        #warn check
        #prompt for input / SAVE
        #verify legal move; re-prompt
    end

    def toggle_player
        @current_player = @current_player == @white ? @black : @white
    end
    
    def save 

    end
end