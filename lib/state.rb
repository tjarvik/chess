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
        #nothing = "
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

    def opponent(color)
        color == "W" ? "B" : "W"
    end

    def rc_diff(from_sq, to_sq)
        row_diff = to_sq[0].to_i - from_sq[0].to_i
        col_diff = to_sq[1].to_i - from_sq[1].to_i
        return row_diff, col_diff
    end

    def check?(for_color)
        k_square = locate_king(for_color)
        square_threatened(for_color.opponent)
    end


    def square_threatened?(square, by_color)
        8.times do |row|
            8.times do |col|
                piece = @squares[row][col]
                next if piece == nil
                if piece[0] == by_color 
                    return true if threatens?([row, col], square)
                end
            end
        end
        false
    end

    def threatens?(from_sq, to_sq)
        piece = @squares[from_sq[0]][from_sq[1]]
        can_capture?(from_sq, to_sq, piece)
    end

    def can_capture?(from_sq, to_sq, piece)

    end

    def can_go?(from_sq, to_sq, piece)

    end

    def path_clear?(from_sq, to_sq, piece)
        return true if piece[1] == "N"
        row_diff, col_diff = rc_diff(from_sq, to_sq)
        row_direction = row_diff == 0 ? 0 : row_diff / row_diff.abs
        col_direction = col_diff == 0 ? 0 : col_diff / col_diff.abs
        diff = [row_diff.abs, col_diff.abs].max
        diff.times do |n|
            next if n == 0
            this_row = from_sq[0] + n * row_direction
            this_col = from_sq[1] + n * col_direction
            return false if @squares[this_col][this_row]
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
    
    def checkmate?(for_color)
        false
    end

    def castling_allowed?(for_color)

    end
end



class King
    def legal?(from, to)
        row_diff, col_diff = rc_diff(from, to)
        return true if row_diff.abs <= 1 && col_diff.abs <= 1
        #castling rules:
        return false if self.ever_moved
        if row_diff == 0 && col_diff.abs == 2
            rook_col = row_diff == 2 ? "h" : "a"
            rook_square = "#{rook_col}#{from[1]}"
            rook = @board.squares[rook_square].piece
            return false if rook.nil?
            return false if rook.ever_moved
            return false unless path_clear?(from, rook_square)
            ###return false if current or intervening square threatened
            return true
        end
        false
    end
end

class Queen 
    def legal?(from, to)
        row_diff, col_diff = rc_diff(from, to)
        row_diff == 0 || col_diff == 0 || row_diff.abs == col_diff.abs
    end

end

class Rook 
    def legal?(from, to)
        row_diff, col_diff = rc_diff(from, to)
        row_diff == 0 || col_diff == 0
    end

end

class Bishop
    def legal?(from, to)
        row_diff, col_diff = rc_diff(from, to)
        row_diff.abs == col_diff.abs
    end
end

class Knight 
    def legal?(from, to)
        row_diff, col_diff = rc_diff(from, to)
        row_diff.abs == 1 && col_diff.abs == 2 || row_diff.abs == 2 && col_diff.abs == 1
    end
end

class Pawn
    def legal?(from, to)
        row_diff, col_diff = rc_diff(from, to)
        direction = self.color == "W" ? 1 : -1
        return false if col_diff.abs > 1
        return false unless row_diff == direction || row_diff == direction * 2
        row = from[1].to_i
        col = from[0].ord - 96
        if col_diff == 0 #move forward
            return false if @board.squares["#{from[0]}#{row + direction}"].piece
            if row_diff == 2
                return false if self.ever_moved == true
                self.just_moved = true
            end
        else #capture
            return false if row_diff != direction
            if @board.squares[to].piece.nil? 
                en_passant = @board.squares["#{to[0]}#{from[1]}"].piece
                return false if en_passant.nil?
                return false unless en_passant.is_a?(Pawn)
                return false if en_passant.color == self.color
                return false unless en_passant.just_moved == true
                en_passant = nil ###destroy it now?
            else
                return false if @board.squares[to].piece.color == self.color
            end 
        end
        true
    end
end