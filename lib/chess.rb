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

    def in_check?
        king_id = "#{@name[0]}K"
        false
    end
end

class Game
    def initialize
        @@checkmate = false
        @white = Player.new("White")
        @black = Player.new("Black")
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
        move = prompt_move
        make_move(move)
        toggle_player
        puts "turn over"
        exit### plays one turn only
    end

    def prompt_move
        puts "Check!" if @current_player.in_check?
        puts "#{@current_player.name}'s move. Enter your move or type SAVE to save game:"
        input = gets.chomp
        until check_format(input)
            puts "Invalid move. Enter move in coordinate format, e.g., e2-e4"
            input = gets.chomp
        end
        until legal_move(input)
            puts "#{input} is not a legal move. Enter move:"
            input = gets.chomp
        end
        input.downcase
    end

    def check_format(input)
        save if input =~ /SAVE/i
        input =~ /^[A-H][1-8]-[A-H][1-8]$/i
    end

    def legal_move(move)
        #is there a piece on initial square?
        #ObjectSpace.each_object(Piece) do |piece|

        #is it your piece?
        #can it go to the final square?
        #is something in the way?
        #if piece on final square, is it opponent's?
        #if pawn, special capture rules
        #if king, moving into check
        #special castle rules
        true
    end

    def make_move(move)
        #find the piece on that square
        #assign it new location
        #if piece captured, destroy it
    end

    def toggle_player
        @current_player = @current_player == @white ? @black : @white
    end
    
    def save 
        #save file
        puts "Game saved."
        exit
    end
end

game = Game.new
game.play