require 'json'

def load_dictionary(file)
  words = File.readlines(file).map(&:chomp)
  words.select { |word| word.length.between?(5, 12) }
end

def pick_secret_word(words)
  words.sample
end

def display_progress(secret_word, guessed_letters)
  progress = secret_word.chars.map { |char| guessed_letters.include?(char) ? char : '_' }.join(' ')
  puts "Word: #{progress}"
end

def display_status(incorrect_word, max_word)
  puts "Incorrect guesses: #{incorrect_word.join(', ')}"
  puts "Guesses left: #{max_word - incorrect_word.size}"
end

def save_game(secret_word, guessed_letters, incorrect_word, max_word)
  game_state = {
    secret_word: secret_word,
    guessed_letters: guessed_letters,
    incorrect_word: incorrect_word,
    max_word: max_word
  }
  File.write('save_game.json', JSON.dump(game_state))
  puts 'Game Saved'
end

def load_game
  if File.exist?('save_game.json')
    game_state = JSON.parse(File.read('save_game.json'), symbolize_names: true)
    puts 'Game loaded'
    return game_state
  end
  nil
end

dictionary_file = 'google-10000-english-no-swears.txt'

# Ask the user if they want to load a saved game or start a new game
puts 'Welcome to the game! Do you want to load a saved game? (y/n)'
load_choice = gets.chomp.downcase

if load_choice == 'y'
  save_game = load_game
  if save_game
    secret_word = save_game[:secret_word]
    guessed_letters = save_game[:guessed_letters]
    incorrect_word = save_game[:incorrect_word]
    max_word = save_game[:max_word]
  else
    puts 'No saved game found, starting a new game...'
    words = load_dictionary(dictionary_file)
    secret_word = pick_secret_word(words)
    guessed_letters = []
    incorrect_word = []
    max_word = 10
  end
else
  words = load_dictionary(dictionary_file)
  secret_word = pick_secret_word(words)
  guessed_letters = []
  incorrect_word = []
  max_word = 10
  puts 'Secret word selected!'
end

while incorrect_word.size < max_word && secret_word.chars.any? { |char| !guessed_letters.include?(char) }
  display_progress(secret_word, guessed_letters)
  display_status(incorrect_word, max_word)

  print 'Enter a letter (or type "save" to save the game): '
  guess = gets.chomp.downcase

  if guess == 'save'
    save_game(secret_word, guessed_letters, incorrect_word, max_word)
    next
  end

  if guess.match?(/^[a-z]$/) # Ensure valid single-letter input
    if guessed_letters.include?(guess) || incorrect_word.include?(guess)
      puts 'You already guessed that letter!'
    elsif secret_word.include?(guess)
      guessed_letters << guess
      puts 'Correct!'
    else
      incorrect_word << guess
      puts 'Incorrect!'
    end
  else
    puts 'Invalid input. Please enter a single letter.'
  end
end

display_progress(secret_word, guessed_letters)
if incorrect_word.size >= max_word
  puts "Game over! The secret word was: #{secret_word}"
else
  puts 'Congratulations! You guessed the word!'
end
