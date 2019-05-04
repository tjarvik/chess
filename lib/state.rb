class State
    attr_accessor :squares

    def initialize(squares=[  ["BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"],
                              ["BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              ["WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"],
                              ["WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"]])
        #nothing = " # because text editor is messing up quote coloration above
        @squares = squares
    end

    def display
        puts "    _______________________________"
        8.times do |row|
            chars = unicode(squares[row])
            puts "#{8 - row}  | #{chars.join(" | ")} |"
            puts "   |___|___|___|___|___|___|___|___|"
        end
        puts "     a   b   c   d   e   f   g   h"
    end

    def unicode(pieces)
        unicodes = {"WK" => "\u2654", "WQ" => "\u2655", "WR" => "\u2656",
                    "WB" => "\u2657", "WN" => "\u2658", "WP" => "\u2659",
                    "BK" => "\u265A", "BQ" => "\u265B", "BR" => "\u265C",
                    "BB" => "\u265D", "BN" => "\u265E", "BP" => "\u265F",
                    nil => " "}
        pieces.map{|piece| unicodes[piece].encode('utf-8')}
    end

    def rc_diff(from_sq, to_sq)
        row_diff = to_sq[0].to_i - from_sq[0].to_i
        col_diff = to_sq[1].to_i - from_sq[1].to_i
        return row_diff, col_diff
    end

    def check?(for_color)
        k_square = locate_king(for_color)
        opponent = for_color == "W" ? "B" : "W"
        square_threatened?(k_square, opponent)
    end

    def square_threatened?(square, by_color)
        8.times do |row|
            8.times do |col|
                piece = @squares[row][col]
                next if piece == nil
                if piece[0] == by_color 
                    return true if can_go?([row, col], square)
                end
            end
        end
        false
    end

    def can_go?(from_sq, to_sq)
        row_diff, col_diff = rc_diff(from_sq, to_sq)
        piece = @squares[from_sq[0]][from_sq[1]]
        capture_piece = @squares[to_sq[0]][to_sq[1]]
        if capture_piece
            return false if capture_piece[0] == piece[0]
            if piece[1] == "P"
                row_diff, col_diff = rc_diff(from_sq, to_sq)
                direction = piece[0] == "W" ? -1 : 1
                return row_diff == direction && col_diff.abs == 1
            end
        end
        case piece[1]
        when "K"
            row_diff.abs <= 1 && col_diff.abs <= 1
            #or castling
        when "Q"
            (row_diff == 0 || col_diff == 0 || row_diff.abs == col_diff.abs) &&
                path_clear?(from_sq, to_sq)
        when "R"
            (row_diff == 0 || col_diff == 0) && path_clear?(from_sq, to_sq)
        when "B"
            row_diff.abs == col_diff.abs && path_clear?(from_sq, to_sq)
        when "N"
            row_diff.abs == 1 && col_diff.abs == 2 || row_diff.abs == 2 && col_diff.abs == 1
        when "P"
            direction = piece[0] == "W" ? -1 : 1
            start_row = piece[0] == "W" ? 6 : 1
            col_diff == 0 && (row_diff == direction || 
                row_diff == direction * 2 && from_sq[0] == start_row && 
                path_clear?(from_sq, to_sq))
        end
    end

    def path_clear?(from_sq, to_sq)
        row_diff, col_diff = rc_diff(from_sq, to_sq)
        row_direction = row_diff == 0 ? 0 : row_diff / row_diff.abs
        col_direction = col_diff == 0 ? 0 : col_diff / col_diff.abs
        diff = [row_diff.abs, col_diff.abs].max
        diff.times do |n|
            next if n == 0
            this_row = from_sq[0] + n * row_direction
            this_col = from_sq[1] + n * col_direction
            return false if @squares[this_row][this_col]
        end
        true
    end

    def locate_king(color)
        king = "#{color}K"
        8.times do |row|
            8.times do |col|
                return [row, col] if @squares[row][col] == king
            end
        end
    end
    
    def all_legal(color)
        legals = []

    end

    def checkmate?(for_color)
        false
    end

    def castling_allowed?(for_color)

    end
end