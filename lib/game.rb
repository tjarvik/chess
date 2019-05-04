require './lib/state.rb'
class Game

    def initialize
        @checkmate = false
        @board = State.new
        @current_player = "W"
        @current_player_name = "White"
    end

    def play
        @board.display
        take_turn until @checkmate
    end

    def take_turn
        move = prompt_move
        @board.make_move(move)
        @board.display
        toggle_player
        test_checkmate
    end

    def test_checkmate
        if @board.check?(@current_player)
            if @board.checkmate?(@current_player)
                puts "Checkmate!"
                @checkmate = true
            else
                puts "Check!"
            end
        end            
    end

    def toggle_player
        @current_player_name = @current_player == "W" ? "Black" : "White"
        @current_player = @current_player == "W" ? "B" : "W"
    end

    def prompt_move
        puts "#{@current_player_name}'s move. Enter your move or type SAVE/LOAD for saved games:"
        loop do
            input = gets.chomp.strip.downcase
            save_game if input =~ /save/
            load_game if input =~ /load/
            unless input =~ /^[a-h][1-8]\-[a-h][1-8]$/
                puts "Invalid move. Enter move in coordinate format, e.g., e2-e4"
                next
            end
            if legal_move?(input)
                valid_move = true
                return alpha_to_rc(input)
            else
                puts "#{input} is not a legal move. Enter move:"
                next
            end
        end
    end

    def legal_move?(move)
        move = alpha_to_rc(move)
        from_sq = move[0]
        to_sq = move[1]
        piece = @board.squares[from_sq[0]][from_sq[1]]
        return false if piece.nil?
        return false if from_sq == to_sq
        return false if piece[0] != @current_player
        @board.can_go?(from_sq, to_sq)
    end

    def alpha_to_rc(raw_input)
        from_sq = [8 - raw_input[1].to_i, raw_input[0].ord - 97]
        to_sq =   [8 - raw_input[4].to_i, raw_input[3].ord - 97]
        return [from_sq, to_sq]
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

game = Game.new
game.play




