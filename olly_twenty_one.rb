# def initialize_deck
# 	new_deck = {}
# 	deck_value = 0	
# 	suits = [:hearts, :diamonds, :spades, :clubs]
# 	suits_idx = 0
# 	face_cards = [:ace, :jack, :queen, :king]
# 	face_cards_idx = 0
# 	card_num = 2

# 	loop do            # for all 52 cards
# 		loop do                 # for each suit
# 			new_deck[deck_value] = [face_cards[face_cards_idx], suits[suits_idx], 1]
# 			deck_value += 1
# 			loop do             # for cards 2..10
# 				new_deck[deck_value] = [card_num, suits[suits_idx], card_num]
# 				card_num += 1
# 				deck_value += 1
# 				if card_num >= 11
# 					card_num = 2
# 					break
# 				end
# 			end
# 			loop do          # for jack, queen, king
# 				face_cards_idx += 1
# 				new_deck[deck_value] = [face_cards[face_cards_idx], suits[suits_idx], 10]
# 				deck_value += 1
# 				if face_cards_idx >= 3
# 					face_cards_idx = 0
# 					break
# 				end
# 			end
# 			suits_idx += 1
# 			break if suits_idx >= 4
# 		end
# 	break if deck_value >= 52
# 	end
# 	new_deck
# end

def initialize_deck
  deck = []
  suits = [:hearts, :diamonds, :spades, :clubs]
  ranks = [:ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king]
  suits.each do |suit|
    ranks.each.with_index(1) do |rank, index|
      score = (index > 10) ? 10 : index
      deck << [rank, suit, score]
    end
  end
  deck
end

def prompt(msg)
  puts "=> #{msg}"
end

def remove_card(deck)
	max_position = deck.length - 1
  random_position = (0..max_position).to_a.sample
  deck.delete_at(random_position)
end

def deal_cards(empty_hand, deck)
	counter = 0
	loop do
		chosen_card = remove_card(deck)
		if chosen_card != nil
			empty_hand[counter] = chosen_card
			counter += 1
	 	end
	 break if counter >= 2
	end
	empty_hand
end

def score_calculator(hand)    
	score = 0
	score += hand[0][-1]
	score += hand[1][-1] 
	cards_scored = 2
	loop do
		if cards_scored == number_of_cards
			return score 
		end
		score += hand[cards_scored][-1]
		cards_scored += 1
	end
	score
end

def win_bust_or_continue(score)
	if score == 21
		return "win"
	elsif score > 21
		return "bust"
	else
		return "continue"
	end
end

def stop_playing?
	loop do
		prompt("play again?(y/n")
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

def print_hand(hand, card_added)
	counter = hand.size
	message =	"#{hand[0][0]} of #{hand[0][1]}, #{hand[1][0]} of #{hand[1][1]}"
	if card_added
		added_card = hand[counter-1]
		prompt("now adding #{added_card[0]} of #{added_card[1]}")
	end
	loop do
		break if counter == 2
		added_card = hand[counter-1]
		message += ", #{added_card[0]} of #{added_card[1]}"
		counter -= 1
	end
	message
end

def hit(hand, deck)
	removed_card = ''
	loop do
		removed_card = remove_card(deck)
		break if removed_card != nil
	end
	hand << removed_card
end

def display_player_score(player_cards)
	prompt("your score is #{score_calculator(player_cards)}")
end

def player_hits(player, deck)  
	player = hit(player, deck)
	player
end

def calculate_winner(compare_scores)
	player_points = compare_scores[0]
	dealer_points = compare_scores[1]
	winner = ''
	case
	when player_points == 21 || dealer_points > 21 
		winner = 'player'
	when dealer_points == 21 || player_points > 21 
		winner = 'dealer'
	when player_points > dealer_points 
		winner = 'player'
	when dealer_points > player_points
		winner = 'dealer'
	when dealer_points == player_points
		winner = 'draw'
	end
	winner
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

def compare_scores(player, dealer, player_hand_points, dealer_hand_points)
	dealer_hand_points = score_calculator(dealer)
	player_hand_points = score_calculator(player)
	prompt("dealer has #{dealer_hand_points}, player has #{player_hand_points}.")
	[player_hand_points, dealer_hand_points]
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
	prompt("Player has won #{game_wins[0]} game(s), dealer has won #{game_wins[1]} game(s).")
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
	prompt("dealer has #{print_hand(dealer, card_added)}")
	# CARD ADDING PHASE
	loop do
		# PLAYER TURN
		loop do
			display_player_score(player)
			# BREAK (IF PLAYER BUST OR WIN) FROM PLAYER TURN
			bust_or_win = win_bust_or_continue(score_calculator(player))
			break if  bust_or_win == "bust"|| bust_or_win == "win"
			# HIT 
			break if hit_or_stay != 'h'
			player = player_hits(player, deck) 
			card_added = true
			prompt("player has #{print_hand(player, card_added)}")
			card_added = false
		end
		# BREAK (IF PLAYER BUST OR WIN) FROM CARD ADDING PHASE
		bust_or_win = win_bust_or_continue(score_calculator(player))
		if  bust_or_win == "bust"
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
	dealer_hand_points = 0
	player_hand_points = 0
	compared_scores = compare_scores(player, dealer, player_hand_points, dealer_hand_points)
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