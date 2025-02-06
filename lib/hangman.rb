require 'securerandom'

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

def display_status(incorrect_guesses, max_attempts)
  puts "Incorrect guesses: #{incorrect_guesses.join(', ')}"
  puts "Attempts remaining: #{max_attempts - incorrect_guesses.size}"
end

while incorrect_guesses.size < max_attempts && secret_word.chars.any? { |char| !guessed_letters.include?(char) }
  display_progress(secret_word, guessed_letters)
  display_status(incorrect_guesses, max_attempts)

  print 'Enter a letter: '
  guess = gets.chomp.downcase

  if guess.match?(/^[a-z]$/)

  end

end

dictionary_file = 'google-10000-english-no-swears.txt'
words = load_dictionary(dictionary_file)
secret_word = pick_secret_word(words)

guessed_letters = []
incorrect_guesses = []
max_attempts = 10
