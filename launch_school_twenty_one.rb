SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
WINNING_NUMBER = 21
DEALER_BREAKS_NUM = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > WINNING_NUMBER
  end

  sum
end

def busted?(cards)
  total(cards) > WINNING_NUMBER
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > WINNING_NUMBER
    :player_busted
  elsif dealer_total > WINNING_NUMBER
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def games_won_counter(outcome, dealer_wins, player_wins, draws)
	if outcome == :player_busted || outcome == :dealer
		dealer_wins += 1
	elsif outcome == :dealer_busted || outcome == :player
		player_wins += 1
	elsif outcome == :tie
		draws += 1
	end
	[player_wins, dealer_wins, draws]
end

def display_result(dealer_cards, player_cards)
  result = detect_result(dealer_cards, player_cards)

  case result	
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def display_games(player_games, dealer_games)
	prompt "player has won #{player_games} game(s), dealer has won #{dealer_games} game(s)."
end

def draw?()

end

def grand_output
	prompt "Thank you for playing Twenty-One! Good bye!"
end

player_wins = 0
dealer_wins = 0
draws = 0
games_counter = 0

loop do
  prompt "Welcome to Twenty-One!"
	games_counter += 1
  # initialize vars
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  # initial deal
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end
	player_points = total(player_cards)
  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{player_cards[0]} and #{player_cards[1]}, for a total of #{player_points}."

  # player turn
  loop do
    player_turn = nil
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Sorry, must enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
			player_points = total(player_cards)
      prompt "You chose to hit!"
      prompt "Your cards are now: #{player_cards}"
      prompt "Your total is now: #{player_points}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_result(dealer_cards, player_cards)
		dealer_wins += 1
		display_games(player_wins, dealer_wins)
    play_again? ? next : grand_output && break
  else
    prompt "You stayed at #{player_points}"
  end

  # dealer turn
  prompt "Dealer turn..."
	dealer_points = total(dealer_cards)

  loop do
    break if total(dealer_cards) >= DEALER_BREAKS_NUM

    prompt "Dealer hits!"
    dealer_cards << deck.pop
		dealer_points = total(dealer_cards)
    prompt "Dealer's cards are now: #{dealer_cards}"
  end

  if busted?(dealer_cards)
    prompt "Dealer total is now: #{dealer_points}"
    display_result(dealer_cards, player_cards)
		player_wins += 1
		display_games(player_wins, dealer_wins)
		break if player_wins >= 5 || dealer_wins >= 5
    play_again? ? next : grand_output && break
  else
    prompt "Dealer stays at #{dealer_points}"
  end

  # both player and dealer stays - compare cards!
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_points}"
  prompt "Player has #{player_cards}, for a total of: #{player_points}"
	game_wins = games_won_counter(detect_result(dealer_cards, player_cards), dealer_wins, player_wins, draws)
  puts "=============="
	player_wins = game_wins[0]
	dealer_wins = game_wins[1]
	draws = game_wins[2]

  display_result(dealer_cards, player_cards)
	if draws > 0 
		prompt " and there was #{draws} draw(s)."
	end
	display_games(player_wins, dealer_wins)
	if games_counter >= 5
		player_wins > dealer_wins ? wins_5 = 'player' : wins_5 = 'dealer'
		prompt "#{wins_5} has won the best-of-5-games competition!"
		break
	end
  break unless play_again?
end

grand_output
