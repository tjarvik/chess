class Board
    def initialize
        make_pieces("W")
        make_pieces("B")
    end
    
    def make_pieces(color)
        row = color == "W" ? "1" : "8"
        King.new("#{color}K", color, "e#{row}")
        Queen.new("#{color}Q", color, "d#{row}")
        Rook.new("#{color}R1", color, "a#{row}")
        Rook.new("#{color}R2", color, "h#{row}")
        Bishop.new("#{color}B1", color, "c#{row}")
        Bishop.new("#{color}B2", color, "f#{row}")
        Knight.new("#{color}N1", color, "b#{row}")
        Knight.new("#{color}N2", color, "g#{row}")
        row = color == "W" ? "2" : "7"
        "abcdefgh".split("").each do |letter|
            Pawn.new("#{color}P#{letter.ord - 96}", color, "#{letter}#{row}")
        end
    end

    def display
        locations = locate_pieces
        display_string = "    _______________________________\n"
        8.times do |row|
            display_string += "#{8 - row}  |"
            8.times do |column|
                piece = locations[row][column]
                piece_character = piece == " " ? " " : piece.unicode.encode('utf-8')
                display_string += " #{piece_character} |"
            end
            display_string += "\n   |___|___|___|___|___|___|___|___|\n"
        end
        display_string += "     a   b   c   d   e   f   g   h"
        puts display_string
        #letter footer
    end

    def locate_pieces
        locations = empty_board
        ObjectSpace.each_object(Piece) do |piece|
            column, row = piece.location.split("")
            locations[8 - row.to_i][column.ord - 97] = piece
        end
        locations
    end

    def empty_board
        locations = []
        8.times do
            row = []
            8.times do
                row << " "
            end
            locations << row
        end
        locations
    end

end

class Piece
    attr_accessor :id
    attr_accessor :color
    attr_accessor :location

    def initialize(id, color, location)
        @id = id
        @color = color
        @location = location
    end

end

class King < Piece
    def unicode 
        self.color == "W" ? "\u2654" : "\u265A"
    end

    def in_check?

    end

    def in_checkmate?

    end
end

class Queen < Piece
    def unicode 
        self.color == "W" ? "\u2655" : "\u265B"
    end
end

class Rook < Piece
    def unicode 
        self.color == "W" ? "\u2656" : "\u265C" 
    end
end

class Bishop < Piece
    def unicode 
        self.color == "W" ? "\u2657" : "\u265D"
    end
end

class Knight < Piece
    def unicode 
        self.color == "W" ? "\u2658" : "\u265E"
    end
end

class Pawn < Piece
    def unicode 
        self.color == "W" ? "\u2659" : "\u265F"
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
        @white = Player.new("white")
        @black = Player.new("black")
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
        exit##one turn
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

game = Game.new
game.play