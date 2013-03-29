#Complete HW assignment, lacks AI

class Menu < Object

	attr_accessor :p1, :p2

	def initialize
		@p1 = nil
		@p2 = nil
	end

	def greeting
		puts ""
		puts "***********************"
		puts "Welcome to Tic-Tac-Toe!"
	end

	def p1_name
		puts "Player 1 name?"
		@p1 = gets.chomp
	end

	def p2_name
		puts "Player 2 name?"
		@p2 = gets.chomp
	end

	def intro
		greeting
		p1_name
		p2_name
	end
end


class Player < Object

	attr_accessor :moves_hash, :name, :marker

	def initialize
		@name = nil
		@marker = nil
		@moves_hash = {}
		clear_moves	
	end

	def clear_moves
		9.times{ |i| @moves_hash[i+1] = false}
	end

	def update_moves (move)
		@moves_hash[move] = true
	end

	def check_win
		return check_horizontal || check_vertical || check_diagonal
	end

	def check_horizontal
		wint = @moves_hash[1] && @moves_hash[2] && @moves_hash[3]
		winm = @moves_hash[4] && @moves_hash[5] && @moves_hash[6]
		winb = @moves_hash[7] && @moves_hash[8] && @moves_hash[9]
		win = wint || winm || winb
		return win
	end

	def check_vertical
		winl = @moves_hash[1] && @moves_hash[4] && @moves_hash[7]
		winm = @moves_hash[2] && @moves_hash[5] && @moves_hash[8]
		winr = @moves_hash[3] && @moves_hash[6] && @moves_hash[9]
		win = winl || winm || winr
		return win
	end

	def check_diagonal
		wint = @moves_hash[1] && @moves_hash[5] && @moves_hash[9]
		winb = @moves_hash[7] && @moves_hash[5] && @moves_hash[3]
		win = wint || winb
		return win
	end
end


class Board < Object

	attr_accessor :board_hash, :move_counter

	def initialize
		@board_hash = {}
		clear
		@move_counter = 0
	end

	def clear
		9.times{ |i| @board_hash[i+1] = "#{i+1}"}
	end
	
	def draw
		puts ""
		puts "   #{@board_hash[1]} | #{@board_hash[2]} | #{@board_hash[3]} "
		puts "  -----------"
		puts "   #{@board_hash[4]} | #{@board_hash[5]} | #{@board_hash[6]} "
		puts "  -----------"
		puts "   #{@board_hash[7]} | #{@board_hash[8]} | #{@board_hash[9]} "
		puts ""
	end

	def valid_move?(move)
		raise Invalid_Entry unless move > 0 && move < 10
	end

	#move should be an integer 0 < i < 10
	def open_move?(move)
		raise Space_Taken unless @board_hash[move].to_i > 0
	end

	#move is an integer 1-9 and player is "X" or "Y"
	def log_move(move, mark)
		@move_counter += 1
		@board_hash[move] = mark
	end

	def check_tie
		if @move_counter == 9
			draw
			puts "THIS GAME ENDED IN A TIE"
			return false
		else
			return true
		end
	end
end

class Game_Exception < Exception
	def message
		"GENERAL GAME EXCEPTION"
	end
end

class Invalid_Entry < Game_Exception
	def message 
		"\nNOT A VALID POSITION."
	end
end

class Space_Taken < Game_Exception
	def message 
		"\nTHIS SPACE IS ALREADY TAKEN."
	end
end

#code starts executing here
m = Menu.new
b = Board.new
p1 = Player.new
p1.marker = "X"
p2 = Player.new
p2.marker = "O"

m.intro
p1.name = m.p1.capitalize
p2.name = m.p2.capitalize

turn = true
game_on = true
num_moves = 0

while game_on
	begin

		move = nil

		if turn
			player = p1
		else
			player = p2
		end

		b.draw
		puts player.name + " you're up!"
		puts "What's your move?"
		move = gets.chomp.to_i

		b.valid_move?(move)
		b.open_move?(move)

		b.log_move(move, player.marker)
		player.update_moves(move)
		turn = !turn

		if player.check_win
			game_on = false
			puts ""
			puts "**Congrats #{player.name}!! You win!!**"
			b.draw
			break
		end			
		
		game_on = b.check_tie

	rescue Game_Exception => ex
		puts ex.message	
		retry
	end
end
puts "**** GAME OVER ****\n"