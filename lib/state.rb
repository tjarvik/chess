class State
    require 'yaml'
    attr_accessor :squares

    def initialize(squares=[  ["BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"],
                              ["BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              [ nil,  nil,  nil,  nil,  nil,  nil,  nil,  nil],
                              ["WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"],
                              ["WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"]],
                    ep = nil, hm = {})

        #nothing = " # because text editor is messing up quote coloration above
        @squares = squares
        @en_passant_square = ep
        @have_moved = hm
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
        return false if from_sq == to_sq
        row_diff, col_diff = rc_diff(from_sq, to_sq)
        piece = @squares[from_sq[0]][from_sq[1]]
        capture_piece = @squares[to_sq[0]][to_sq[1]]
        if capture_piece
            return false if capture_piece[0] == piece[0]
        end
        case piece[1]
        when "K"
            row_diff.abs <= 1 && col_diff.abs <= 1 || castling?(from_sq, to_sq, piece)
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
            if col_diff == 0 && @squares[to_sq[0]][to_sq[1]].nil?
                return true if row_diff == direction
                return true if row_diff == direction * 2 && from_sq[0] == start_row && 
                    path_clear?(from_sq, to_sq)
            elsif row_diff == direction && col_diff.abs == 1
                return true if capture_piece 
                return true if @en_passant_square == to_sq
            end
            false
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

    def castling?(from_sq, to_sq, piece)
        row_diff, col_diff = rc_diff(from_sq, to_sq)
        opponent = piece[0] == "W" ? "B" : "W"
        return false unless col_diff.abs == 2 && row_diff == 0
        return false if square_threatened?(from_sq, opponent)
        return false if square_threatened?(to_sq, opponent)
        direction = col_diff / col_diff.abs
        interim_sq = [from_sq[0], from_sq[1] + direction]
        return false if square_threatened?(interim_sq, opponent)
        rook_col = direction == 1 ? 7 : 0
        rook_sq = [from_sq[0], rook_col]
        return false unless @squares[from_sq[0]][rook_col]
        return false unless @squares[from_sq[0]][rook_col][1] == "R"
        return false unless path_clear?(from_sq, rook_sq)
        return false if @have_moved[from_sq]
        return false if @have_moved[rook_sq]
        @castling = true
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
    
    def get_all_legals(color)
        legals = []
        8.times do |row|
            8.times do |col|
                piece = @squares[row][col]
                next if piece.nil?
                next unless piece[0] == color
                piece_legals = get_piece_legals(row, col)
                piece_legals.each {|move| legals << move}
            end
        end
        legals
    end

    def get_piece_legals(from_row, from_col)
        legals = []
        piece = @squares[from_row][from_col]
        8.times do |to_row|
            8.times do |to_col|
                if can_go?([from_row, from_col], [to_row, to_col])
                    legals << [[from_row, from_col], [to_row, to_col]]
                end
            end
        end
        legals
    end

    def check?(for_color)
        k_square = locate_king(for_color)
        opponent = for_color == "W" ? "B" : "W"
        square_threatened?(k_square, opponent)
    end

    def would_be_check?(move, for_color)
        hypothetical = YAML::load(YAML::dump(self))
        hypothetical.make_move(move)
        hypothetical.check?(for_color)
    end

    def mate?(for_color) 
        legals = get_all_legals(for_color)
        legals.each do |move|
            hypothetical = YAML::load(YAML::dump(self))
            hypothetical.make_move(move)
            return false if !hypothetical.check?(for_color)
        end
        true
    end

    def make_move(move)
        from_sq = move[0]
        to_sq = move[1]
        row_diff, col_diff = rc_diff(from_sq, to_sq)
        piece = @squares[from_sq[0]][from_sq[1]]

        if piece[1] == "K" && col_diff.abs == 2 #castling
            rook_col = col_diff == 2 ? 7 : 0
            direction = col_diff / col_diff.abs
            rook = @squares[from_sq[0]][rook_col]
            @squares[from_sq[0]][from_sq[1] + direction] = rook
            @squares[from_sq[0]][rook_col] = nil
        end
        @have_moved[from_sq] = true

        if piece[1] == "P" && col_diff.abs == 1 && @squares[to_sq[0]][to_sq[1]].nil? #en passant
            @squares[from_sq[0]][to_sq[1]] = nil
        end
        @en_passant_square = nil
        if piece[1] == "P" && row_diff.abs == 2
            direction = piece[0] == "W" ? -1 : 1
            @en_passant_square = [from_sq[0] + direction, from_sq[1]]
        end

        @squares[to_sq[0]][to_sq[1]] = piece
        @squares[from_sq[0]][from_sq[1]] = nil
    end
end