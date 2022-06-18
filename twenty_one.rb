require 'pry'
require 'active_support/core_ext/hash'
=begin
P:
Create a game of 21 in which you play against the computer
E:

D/A:

1. Initialize deck

a) deck will be a hash of arrays.The keys will be numbers 1 .. 52 (thereby making it accessible with [.rand])
	Each value will be an array containing:
	a first digit/symbol to name the card  (thereby making it accessible with [.rand])
	The second object will be the suit of the card
	The third value will be the score value of the card and for the ace there is a forth object for the alternative value) 
	eg: 44 => [4, :spades, 4]

2. Deal cards to player and dealer

a) dealer and player cards are stored in an array initialized as 0s. Then reassigned using the .rand method

3. Player turn: hit or stay
  - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, player wins.
7. Compare cards and declare winner.
C:
=end

def initialize_deck
	new_deck = {}
	deck_value = 0	
	suits = [:hearts, :diamonds, :spades, :clubs]
	suits_idx = 0
	face_cards = [:ace, :jack, :queen, :king]
	face_cards_idx = 0
	card_num = 2

	loop do            # for all 52 cards
		loop do                 # for each suit
			new_deck[deck_value] = [face_cards[face_cards_idx], suits[suits_idx], 1, 11]
			deck_value += 1
			loop do             # for cards 2..10
				new_deck[deck_value] = [card_num, suits[suits_idx], card_num]
				card_num += 1
				deck_value += 1
				if card_num >= 11
					card_num = 2
					break
				end
			end
			loop do          # for jack, queen, king
				face_cards_idx += 1
				new_deck[deck_value] = [face_cards[face_cards_idx], suits[suits_idx], 10]
				deck_value += 1
				if face_cards_idx >= 3
					face_cards_idx = 0
					break
				end
			end
			suits_idx += 1
			break if suits_idx >= 4
		end
		break if deck_value >= 52
	end
	new_deck
end

def prompt(msg)
  puts "=> #{msg}"
end

def remove_card(deck)
	deck.delete(rand(52))
end

def deal_cards(empty_hand, deck)
	counter = 0
	loop do
		chosen_card = remove_card(deck)
		if !chosen_card.nil?
			empty_hand[counter] = chosen_card
			counter += 1
	 	end
	 break if counter >= 2
	end
	empty_hand
end

def score_calculator(hand)
	score = 0
	# SCORE FROM 0
	loop do
		number_of_cards = hand.size
		score += hand[0][-1]
		score += hand[1][-1]
		cards_scored = 2
		valid_ace_present = scan_hand_for_high_points_ace(hand)
		# SUM OF CARDS
		loop do
			if cards_scored == number_of_cards
				break
			end
			score += hand[cards_scored][-1]
			cards_scored += 1
		end
		# CHECK IF ACE NEEDS TO BE REDUCED
		if valid_ace_present && score > 21
			delete_one_ace_high_points(hand)
			score = 0
		elsif valid_ace_present == false || score < 22
			break
		else
			break
		end
	end
	score
end

def delete_one_ace_high_points(hand)
	hand.each do |card|
		if card[0] == :ace && card[-1] == 11
			card.delete(card[-1])
			break
		end
	end
	hand
end

def scan_hand_for_high_points_ace(hand)
	number_of_cards = hand.size
	valid_ace_present = false
	loop do
		card = hand[number_of_cards - 1]
		if card.include?(:ace) && card.size == 4
			valid_ace_present = true
		end
		number_of_cards -= 1
		break if number_of_cards <= -1
	end
	valid_ace_present
end

def win_bust_or_continue(score)
	if score == 21
		"win"
	elsif score > 21
		"bust"
	else
		"continue"
	end
end

def stop_playing?
	loop do
		prompt("play again?(y/n)")
		answer = gets.downcase.chomp!
		if answer == 'y'
			return false
		elsif answer == 'n'
			return true
		else
			prompt("invalid input")
		end
	end
end

def print_dealer_hand(hand)
 prompt("dealer has #{hand[0][0]} of #{hand[0][1]} and something else")
end

def print_hand(hand, card_added)
	counter = hand.size
	message =	"#{hand[0][0]} of #{hand[0][1]}, #{hand[1][0]} of #{hand[1][1]}"
	if card_added
		added_card = hand[counter - 1]
		# prompt("now adding #{added_card[0]} of #{added_card[1]}")
	end
	loop do
		break if counter == 2
		added_card = hand[counter - 1]
		message += ", #{added_card[0]} of #{added_card[1]}"
		counter -= 1
	end
	message
end

def hit(hand, deck)
	removed_card = ''
	loop do
		removed_card = remove_card(deck)
		break if !removed_card.nil?
	end
	hand << removed_card
end

def display_player_score(player_cards)
	prompt("your score is #{score_calculator(player_cards)}")
end

def calculate_winner(compare_scores)
	player_points = compare_scores[0]
	dealer_points = compare_scores[1]
	if player_points == 21 || dealer_points > 21 || ((player_points > dealer_points) && (player_points < 22))
		'player'
	elsif dealer_points == 21 || player_points > 21 || dealer_points > player_points
		'dealer'
	elsif dealer_points == player_points
		'draw'
	end
end

def hit_or_stay
	answer = ''
	loop do
		prompt("hit or stay?(h/s)")
		answer = gets.downcase.chomp!
		if answer != 'h' && answer != 's'
			prompt("invalid input")
		else break
		end
	end
	answer
end

def dealer_stays?(dealer)
	score = score_calculator(dealer)
	score >= 17 && score <= 20
end

def compare_scores(player, dealer, player_pts, dealer_pts)
	dealer_pts = score_calculator(dealer)
	player_pts = score_calculator(player)
	prompt("dealer has #{dealer_pts}, player has #{player_pts}.")
	[player_pts, dealer_pts]
end

def losing_message
	prompt("You lose.")
end

def winning_message
	prompt("You won - you are truly the greatest")
end

def print_winner(winner)
	if winner == 'player'
		prompt("player wins!")
	elsif winner == 'dealer'
		prompt("dealer wins!")
	elsif winner == 'draw'
		prompt("It's a draw!")
	else
		prompt(" the print_winner method is not working")
	end
end

def calculate_num_of_games_won(winner, player_game_wins, dealer_game_wins)
	if winner == 'player'
		player_game_wins += 1
	elsif winner == 'dealer'
		dealer_game_wins += 1
	end
	[player_game_wins, dealer_game_wins]
end

def print_num_of_games_won(game_wins)
	prompt("player has won #{game_wins[0]} game(s), dealer has won #{game_wins[1]} game(s).")
end

# GAME PLAY
card_added = false
dealer_game_wins = 0
player_game_wins = 0
loop do
	prompt("Welcome to Twenty-One. The dealer will now deal the cards...")
	sleep 3
	bust_or_win = ''
	# PLAYER/DEALER ARE DEALT 2 CARDS
	dealer = [0, 0]
	player = [0, 0]
	deck = initialize_deck
	deal_cards(dealer, deck)
	deal_cards(player, deck)
	prompt("player has #{print_hand(player, card_added)}")
	print_dealer_hand(dealer)
	# CARD ADDING PHASE
	loop do
		# PLAYER TURN
		loop do
			display_player_score(player)
			# BREAK (IF PLAYER BUST OR WIN) FROM PLAYER TURN
			bust_or_win = win_bust_or_continue(score_calculator(player))
			break if bust_or_win == "bust" || bust_or_win == "win"
			# HIT
			break if hit_or_stay != 'h'
			player = hit(player, deck)
			card_added = true
			prompt("player has #{print_hand(player, card_added)}")
			card_added = false
		end
		# BREAK (IF PLAYER BUST OR WIN) FROM CARD ADDING PHASE
		bust_or_win = win_bust_or_continue(score_calculator(player))
		if bust_or_win == "bust"
			losing_message
			break
		elsif bust_or_win == "win"
			winning_message
			break
		end
			prompt("dealer's turn...")
			sleep 3
		# DEALER TURN
		loop do
			prompt("dealer has #{print_hand(dealer, card_added)}")
			card_added = false
			prompt("dealer's score is #{score_calculator(dealer)}")
			dealer_won_or_bust = win_bust_or_continue(score_calculator(dealer))
			dealer_stays = dealer_stays?(dealer)
			if dealer_won_or_bust == "win" || dealer_won_or_bust == "bust"
				break
			elsif dealer_stays
				sleep 2
				prompt("dealer stays")
				break
			end
		# DEALER HITS
			prompt("dealer hits...")
			sleep 2
			hit(dealer, deck)
			card_added = true
		end
		break
	end
 #	COMPARE SCORES PHASE
	dealer_hand_pts = 0
	player_hand_pts = 0
	compared_scores = compare_scores(player, dealer, player_hand_pts, dealer_hand_pts)
	winner = calculate_winner(compared_scores)
	print_winner(winner)
	game_wins = calculate_num_of_games_won(winner, player_game_wins, dealer_game_wins)
	print_num_of_games_won(game_wins)
	if stop_playing?
		prompt("well, I hope you enjoyed yourself. Come back soon!")
		break
	end 
	player_game_wins = game_wins[0]
  dealer_game_wins = game_wins[1]
end

# Questions:

# 	1.

#		In tic_tac_toe we had a method to initialize the board. It seems that here I am also expected to initialize he deck.
# 	Why can't these merely be constants?

# 2.

#   My method of doing select all in a delete_me.rb file - is that something other people do?

# 3.

#   is exit-p(rogram) the only way to get out of pry?