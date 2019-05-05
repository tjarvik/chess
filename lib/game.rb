require './lib/state.rb'
class Game
    attr_accessor :board
    attr_accessor :current_player
    
    def initialize
        @game_over = false
        @board = State.new
        @current_player = "W"
        @current_player_name = "White"
    end

    def play
        @board.display
        take_turn until @game_over
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
            if @board.mate?(@current_player)
                puts "Checkmate!"
                @game_over = true
            else
                puts "Check!"
            end
        elsif @board.mate?(@current_player)
            puts "Stalemate."
            @game_over = true
        end           
    end

    def toggle_player
        @current_player_name = @current_player == "W" ? "Black" : "White"
        @current_player = @current_player == "W" ? "B" : "W"
    end

    def prompt_move
        puts "#{@current_player_name}'s move. Enter your move or type SAVE/LOAD for saved game:"
        loop do
            input = gets.chomp.strip.downcase
            save_game if input =~ /save/
            load_game if input =~ /load/
            unless input =~ /^[a-h][1-8]\-[a-h][1-8]$/
                puts "Invalid move. Enter move in coordinate format, e.g., e2-e4"
                next
            end
            move = alpha_to_rc(input)
            if legal_move?(move)
                valid_move = true
                return move
            else
                puts "#{input} is not a legal move. Enter move:"
                next
            end
        end
    end

    def legal_move?(move)
        from_sq = move[0]
        to_sq = move[1]
        piece = @board.squares[from_sq[0]][from_sq[1]]
        return false if piece.nil?
        return false unless piece[0] == @current_player
        return false unless @board.can_go?(from_sq, to_sq)
        return false if @board.would_be_check?(move, @current_player)
        true
    end

    def alpha_to_rc(raw_input)
        from_sq = [8 - raw_input[1].to_i, raw_input[0].ord - 97]
        to_sq =   [8 - raw_input[4].to_i, raw_input[3].ord - 97]
        return [from_sq, to_sq]
    end

    def save_game
        id = "1.txt"
        Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
        filename = "saved_games/game_#{id}"
        File.open(filename,'w') {|file| file.puts YAML::dump(self)}
        puts "Game saved."
        exit
    end
    
    def load_game
        @game_over = true
        filename = "saved_games/game_1.txt"
        new_game = YAML::load(File.read(filename))
        new_game.play
    end
end



#game = Game.new
#game.play




