class Board
    attr_accessor :squares

    def initialize
        @squares = {}
        "abcdefgh".split("").each do |letter|
            8.times do |number|
                @squares["#{letter}#{number + 1}"] = nil
            end
        end
    end

    def display
        display_string = "    _______________________________\n"
        8.times do |raw_row|
            row = 8 - raw_row
            display_string += "#{row}  |"
            "abcdefgh".split("").each do |column|
                piece = @squares["#{column}#{row}"]
                piece_character = piece == nil ? " " : piece.unicode.encode('utf-8')
                display_string += " #{piece_character} |"
            end
            display_string += "\n   |___|___|___|___|___|___|___|___|\n"
        end
        display_string += "     a   b   c   d   e   f   g   h"
        puts display_string
    end
end

class Piece
    attr_accessor :id
    attr_accessor :color

    def initialize(id, color)
        @id = id
        @color = color
    end

    def rc_diff(from, to)
        row_diff = to[1].to_i - from[1].to_i
        col_diff = to[0].ord - from[0].ord
        return row_diff, col_diff
    end
end

class King < Piece
    def unicode 
        self.color == "W" ? "\u2654" : "\u265A"
    end

    def legal?(from, to, squares)
        row_diff, col_diff = rc_diff(from, to)
        row_diff.abs <= 1 && col_diff.abs <= 1
        ##or castles
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

    def legal?(from, to, squares)
        row_diff, col_diff = rc_diff(from, to)
        row_diff == 0 || col_diff == 0 || row_diff.abs == col_diff.abs
    end

end

class Rook < Piece
    def unicode 
        self.color == "W" ? "\u2656" : "\u265C" 
    end

    def legal?(from, to, squares)
        row_diff, col_diff = rc_diff(from, to)
        row_diff == 0 || col_diff == 0
    end

end

class Bishop < Piece
    def unicode 
        self.color == "W" ? "\u2657" : "\u265D"
    end

    def legal?(from, to, squares)
        row_diff, col_diff = rc_diff(from, to)
        row_diff.abs == col_diff.abs
    end
end

class Knight < Piece
    def unicode 
        self.color == "W" ? "\u2658" : "\u265E"
    end

    def legal?(from, to, squares)
        row_diff, col_diff = rc_diff(from, to)
        row_diff.abs == 1 && col_diff.abs == 2 || row_diff.abs == 2 && col_diff.abs == 1
    end
end

class Pawn < Piece
    def unicode 
        self.color == "W" ? "\u2659" : "\u265F"
    end

    def legal?(from, to, squares)
        row_diff, col_diff = rc_diff(from, to)
        true #####
    end
end

class Player
    attr_accessor :name
    attr_accessor :color

    def initialize(name, color)
        @name = name
        @color = color
    end

    def in_check?
        king_id = "#{@name[0]}K"
        false
    end
end

class Game
    def initialize
        @@checkmate = false
        @white = Player.new("White", "W")
        @black = Player.new("Black", "B")
        @board = Board.new
        @current_player = @white
        make_pieces("W")
        make_pieces("B")
    end

    def make_pieces(color)
        row = color == "W" ? "1" : "8"
        @board.squares["e#{row}"] = King.new("#{color}K", color)
        @board.squares["d#{row}"] = Queen.new("#{color}Q", color)
        @board.squares["a#{row}"] = Rook.new("#{color}R1", color)
        @board.squares["h#{row}"] = Rook.new("#{color}R2", color)
        @board.squares["c#{row}"] = Bishop.new("#{color}B1", color)
        @board.squares["f#{row}"] = Bishop.new("#{color}B2", color)
        @board.squares["b#{row}"] = Knight.new("#{color}N1", color)
        @board.squares["g#{row}"] = Knight.new("#{color}N2", color)
        row = color == "W" ? "2" : "7"
        "abcdefgh".split("").each do |letter|
            @board.squares["#{letter}#{row}"] = Pawn.new("#{color}P#{letter.ord - 96}", color)
        end
    end

    def play
        take_turn until @@checkmate
    end

    def take_turn
        @board.display
        #checkmate?
        prompt_move
        @current_player = @current_player == @white ? @black : @white
    end

    def prompt_move
        puts "Check!" if @current_player.in_check?
        puts "#{@current_player.name}'s move. Enter your move or type SAVE to save game:"
        input = gets.chomp.downcase
        until check_format(input)
            puts "Invalid move. Enter move in coordinate format, e.g., e2-e4"
            input = gets.chomp.downcase
        end
        until legal_move(input)
            puts "#{input} is not a legal move. Enter move:"
            input = gets.chomp.downcase
        end
        input
    end

    def check_format(input)
        save if input =~ /save/
        input =~ /^[a-h][1-8]-[a-h][1-8]$/
    end

    def legal_move(move)
        from = move[0..1]
        to = move[3..4]
        piece = @board.squares[from]
        return false if piece.nil?
        return false unless piece.color == @current_player.color
        return false if from == to
        return false if piece.legal?(from, to, @board.squares) == false
        #is something in the way?
        #if piece on final square, is it opponent's?
        #if pawn, special capture rules
        #not moving self into check
        #special castle rules
        @board.squares[from] = nil
        @board.squares[to] = piece
        #if piece captured, also destroy it
        true
    end
    
    def save 
        #save file
        puts "Game saved."
        exit
    end

    def load
        #load file
    end
end

game = Game.new
game.play