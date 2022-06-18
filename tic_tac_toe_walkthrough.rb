require 'pry'
INITIAL_MARKER = 	' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
THREATENING_CONFIGURATIONS = [[1, 2], [1, 3], [2, 3], [4, 5], [4, 6], [5, 6], [7, 8], [7, 9], [8, 9]] + # rows
														 [[1, 4], [1, 7], [4, 7], [2, 5], [2, 8], [5, 8], [3, 6], [3, 9], [6, 9]] + # columns
														 [[1, 5], [1, 9], [5, 9], [3, 5], [3, 7], [5, 7]] #diagonals

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + #rows
								[[1, 4, 7], [2 ,5, 8], [3, 6, 9]] + #columns
								[[1, 5, 9], [3, 5, 7]]              #diagonals

def prompt(msg)
  puts "=> #{msg}"
end
	
	def display_board(brd)

		# system 'clear'
		puts "Player = #{PLAYER_MARKER}"
		puts "Computer = #{COMPUTER_MARKER}"
	puts "     |     |"
	puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
	puts "     |     |"
	puts "-----|-----|-----"
	puts "     |     |"
	puts "   #{brd[4]} |  #{brd[5]}  |  #{brd[6]}"
	puts "     |     |"
	puts "-----|-----|-----"
	puts "     |     |"
	puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
	puts "     |     |"
	puts""
end

def initialize_board
	new_board = {}
	(1..9).each {|num| new_board[num] = INITIAL_MARKER}
	new_board
end

def display_score(player_score, computer_score)
	puts "player: #{player_score}, computer: #{computer_score}."
end

def empty_squares(brd)  
	output = brd.keys.select {|num| brd[num] == INITIAL_MARKER}
end

def joiner(array, punctuation = {}, final_and = {})
	if array.size == 1
		"#{array[0]}"
	elsif punctuation.empty? && final_and.empty? 
		"#{array[0..-2].join(',')} or #{array[-1]}" 
	elsif final_and.empty? 
		"#{array[0..-2].join(punctuation)} or #{array[-1]}"
	else
		"#{array[0..-2].join(punctuation)} #{final_and} #{array[-1]}"
	end
end

def player_places_piece!(brd)
	square = INITIAL_MARKER
	loop do
		prompt "Choose a square (#{joiner(empty_squares(brd))})"
		square = gets.chomp.to_i 
			break if brd.keys.select{|num| brd[num] == INITIAL_MARKER}.include?(square)
			puts "That is an invalid input"
		end
	brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
	square = empty_squares(brd).sample
	brd[square] = COMPUTER_MARKER
end

def computer_blocks!(brd)

	THREATENING_CONFIGURATIONS.each do |line|
				if brd[line[0]] == PLAYER_MARKER && 
					 brd[line[1]] == PLAYER_MARKER
					 case
					 when (line == [2, 3] || line == [4, 7] || line == [5, 9]) && (brd[1] == 	INITIAL_MARKER)
						brd[1] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					when (line == [1, 3] || line == [5, 8])  && (brd[2] == 	INITIAL_MARKER)
						brd[2] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					 when (line == [1,2] || line == [6, 9] || line == [5, 7])  && (brd[3] == 	INITIAL_MARKER)
					 	brd[3] = COMPUTER_MARKER
						 puts "Computer blocks"
						 return true
					when (line == [1, 7] || line == [5, 6]) && (brd[4] == 	INITIAL_MARKER)
						brd[4] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					when (line == [4, 6] || line == [2, 8] || line == [1, 9] || line == [3, 7])  && (brd[5] == 	INITIAL_MARKER)
						brd[5] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					when (line == [4, 5] || line == [3, 9])  && (brd[6] == 	INITIAL_MARKER)
						brd[6] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					when (line == [1, 4] || line == [8, 9] || line == [3, 5])  && (brd[7] == 	INITIAL_MARKER)
						brd[7] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					when (line == [2, 5] || line == [7, 9])  && (brd[8] == 	INITIAL_MARKER)
						brd[8] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
					when (line == [3, 6] || line == [7, 8] || line == [1, 5])  && (brd[9] == 	INITIAL_MARKER)
						brd[9] = COMPUTER_MARKER
						puts "Computer blocks"
						return true
				else 
					break	
			end			
		end	  
	nil		
end
end

def board_full?(brd)
	empty_squares(brd).empty?
end

def someone_won?(brd)
	!!detect_winner(brd)
end

def someone_won_5(player_score, computer_score)
	if player_score == 5 
		return "Player"
	elsif computer_score == 5
		return "Computer"
	else
		false
	end
end

def detect_imminent_threat(brd)
	THREATENING_CONFIGURATIONS.map do |line|
		if brd[line[0]] == PLAYER_MARKER && 
			 brd[line[1]] == PLAYER_MARKER
			#  binding.pry 
		case
			when (line == [2, 3] || line == [4, 7] || line == [5, 9]) && (brd[1] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [1, 3] || line == [5, 8]) && (brd[2] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			 when (line == [1,2] || line == [6, 9] || line == [5, 7]) && (brd[3] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [1, 7] || line == [5, 6]) && (brd[4] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [4, 6] || line == [2, 8] || line == [1, 9] || line == [3, 7]) && (brd[5] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [4, 5] || line == [3, 9])  && (brd[6] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [1, 4] || line == [8, 9] || line == [3, 5]) && (brd[7] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [2, 5] || line == [7, 9])  && (brd[8] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			when (line == [3, 6] || line == [7, 8] || line == [1, 5]) && (brd[9] == INITIAL_MARKER)
				prompt("Player is about to win")
				return "Player"
			else 
			break	
			end
		end	
	end
				
		THREATENING_CONFIGURATIONS.map do |line|
			if brd[line[0]] == COMPUTER_MARKER && 
				 brd[line[1]] == COMPUTER_MARKER
				#  binding.pry 
			case
				when (line == [2, 3] || line == [4, 7] || line == [5, 9]) && (brd[1] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [1, 3] || line == [5, 8])  && (brd[2] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				 when (line == [1, 2] || line == [6, 9] || line == [5, 7])  && (brd[3] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [1, 7] || line == [5, 6]) && (brd[4] == 	INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [4, 6] || line == [2, 8] || line == [1, 9] || line == [3, 7]) && (brd[5] ==	INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [4, 5] || line == [3, 9])  && (brd[6] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [1, 4] || line == [8, 9] || line == [3, 5]) && (brd[7] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [2, 5] || line == [7, 9])  && (brd[8] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				when (line == [3, 6] || line == [7, 8] || line == [1, 5])  && (brd[9] == INITIAL_MARKER)
					prompt("Computer is about to win")
					return 'Computer'
				else 
				break	
				end
			end	
		end
	nil
end

def announce_imminent_threat(detected_boolean)
	prompt("#{detected_boolean} is about to win")
end

def detect_winner(brd)

	WINNING_LINES.each do |line|
			if brd[line[0]] == PLAYER_MARKER && 
				 brd[line[1]] == PLAYER_MARKER && 
				 brd[line[2]] == PLAYER_MARKER
				 return 'Player'
			elsif brd[line[0]] == COMPUTER_MARKER && 
				brd[line[1]] == COMPUTER_MARKER && 
				brd[line[2]] == COMPUTER_MARKER
				return 'Computer'
			end
	end
	nil
end

player_score = 0
computer_score = 0
winner_5 = nil

loop do
	board = initialize_board

	loop do
		#DISPLAY
		display_board(board)
		display_score(player_score, computer_score)
		#PLAYER'S TURN
		player_places_piece!(board)
		break if someone_won?(board) || board_full?(board)
		#COMPUTER'S TURN
		detect_imminent_threat(board) == "Player" ? computer_blocks!(board) : computer_places_piece!(board)
		# loop do
			detect_imminent_threat(board)
		# 	break if detect_imminent_threat(board) == nil
		# end
		end
		
	display_board(board)

	if board_full?(board)
		prompt "it' a draw"
	elsif someone_won?(board)
		prompt "#{detect_winner(board)} won!"
		if detect_winner(board) == "Computer"
			computer_score += 1
			puts "continue?(y/n)"
			answer = gets.chomp
			break unless answer.downcase.start_with?('y')
		elsif detect_winner(board) == "Player"
			player_score += 1	
			puts "continue?(y/n)"
			answer = gets.chomp
			break unless answer.downcase.start_with?('y')
		end
	else
			prompt "It's a tie!"
	end

	if someone_won_5(player_score, computer_score)
		puts " #{someone_won_5(player_score, computer_score)} won 5 games."
		prompt "Play again? (y/n)"
		answer = gets.chomp
		break unless answer.downcase.start_with?('y')	
	end

end

prompt "Thanks for playing!"	

# BUG:

# > Choose a square (9)
# 9
# Player = X
# Computer = O
#      |     |
#   X  |  O  |  O
#      |     |
# -----|-----|-----
#      |     |
#    O |  X  |  X
#      |     |
# -----|-----|-----
#      |     |
#   O  |  X  |  X
#      |     |

# => it' a draw         => But i won
# Player = X						=> And it didn't ask me to play again or not.
# Computer = O
#      |     |
#      |     |   
#      |     |
# -----|-----|-----
#      |     |
#      |     |   
#      |     |
# -----|-----|-----
#      |     |
#      |     |   
#      |     |

# player: 1, computer: 0.
# => Choose a square (1,2,3,4,5,6,7,8 or 9)
