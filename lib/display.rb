# frozen-string-literal: true

require_relative 'common'

# Display information about how the game is played, and the current status of the game.
module Display
  include Common

  def intro
    puts 'Welcome to Hangman!'
    puts 'This is a game where you need to guess a 5-12 letter word'
    puts 'by guessing letters one by one.'
    puts 'You can only have 10 incorrect guesses before you lose the game!'
    loop do
      choice = prompt 'Please enter 1 [Play a new game] or 2 [Load a saved game]: '

      return choice if %w[1 2].include?(choice)

      clear
      puts 'Invalid choice, please choose again.'
    end
  end

  def show_round(guess_count, word_progress, correct_guesses, incorrect_guesses)
    puts "Guesses remaining: #{guess_count}"
    puts word_progress.join(' ')
    puts "Correct guesses: #{correct_guesses.join(' ')}"
    puts "Inorrect guesses: #{incorrect_guesses.join(' ')}"
  end

  def victory_message(victory, hidden_word)
    if victory
      puts "\nYou win!\n"
    else
      puts "\nYou lose!\n"
    end
    puts "The hidden word was [#{hidden_word.join.upcase}]!\n\n"
  end
end
