# frozen-string-literal: true

# Blueprint for save file objects
class SaveFile
  attr_reader :hidden_word, :guess_count, :correct_guesses, :incorrect_guesses, :word_progress

  def initialize(hidden_word, guess_count, correct_guesses, incorrect_guesses, word_progress)
    @hidden_word = hidden_word
    @guess_count = guess_count
    @correct_guesses = correct_guesses
    @incorrect_guesses = incorrect_guesses
    @word_progress = word_progress
  end
end
