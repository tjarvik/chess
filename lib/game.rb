require './lib/state.rb'
class Game
    def initialize
        @checkmate = false
        @board = State.new
        @current_player = "W"
    end

    def play
        @board.display
        take_turn until @checkmate
    end

    def take_turn
        move = prompt_move
        make_move(move)
        @board.display
        toggle_player
    end

    def toggle_player
        @current_player = @current_player == "W" ? "B" : "W"
    end

    def prompt_move
        puts "Check!" if @current_player.in_check?
        puts "#{@current_player.name}'s move. Enter your move or type SAVE to save game:"
        input = gets.chomp.downcase
        until check_format(input)
            puts "Invalid move. Enter move in coordinate format, e.g., e2-e4"
            input = gets.chomp.downcase
        end
        #convert format
        until legal_move(input)
            puts "#{input} is not a legal move. Enter move:"
            input = gets.chomp.downcase
        end
        #convert format
        input
    end

    def check_format(input)
        save_game if input =~ /save/
        load_game if input =~ /load/
        input =~ /^[a-h][1-8]\-[a-h][1-8]$/
    end

    def legal_move(move)
        from = move[0..1]
        to = move[3..4]
        piece = @board.squares[from].piece
        captured = @board.squares[to].piece
        return false if piece.nil?
        return false if from == to
        return false if piece.color != @current_player.color
        return false if captured && piece.color == captured.color
        return false if piece.legal?(from, to) == false
        return false if piece.path_clear?(from, to) == false
        @board.squares[from].piece = nil
        @board.squares[to].piece = piece
        ###promote pawns
        ###if castled, move rook too
        if @current_player.in_check?
            ###move it all back -- including castling, ep
            @board.squares[from].piece = piece
            @board.squares[to].piece = captured
            return false
        end
        ObjectSpace.each_object(Piece) do |pc|
            pc.just_moved = false
        end
        piece.just_moved = true
        piece.ever_moved = true
        true
    end

    def save_game
        #save file
        puts "Game saved."
        exit
    end

    def load_game
        #load file
        #set board to saved state
        self.play
    end
end

#game = Game.new
#game.play
board = State.new
board.display



