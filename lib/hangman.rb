# frozen-string-literal: true

require_relative 'display'
require_relative 'common'
require_relative 'savefile'
require 'yaml'

# Full game of hangman, a word guessing game by suggesting letters within a certain # of guesses.
class Hangman
  include Display
  include Common

  attr_accessor :hidden_word, :word_progress

  def initialize
    @hidden_word = choose_word
    @guess_count = 10
    @correct_guesses = []
    @incorrect_guesses = []
    @word_progress = Array.new(@hidden_word.length, '_')
    @saved = false

    choose_game_mode
  end

  def choose_game_mode
    choice = intro

    clear

    choice == '2' ? load_game : play_game
  end

  def play_game
    while @guess_count > 0
      clear
      show_round(@guess_count, @word_progress, @correct_guesses, @incorrect_guesses)
      input_letter
      break if victory? || @saved
    end
    return if @saved

    show_round(@guess_count, @word_progress, @correct_guesses, @incorrect_guesses)

    victory_message(victory?, @hidden_word)
    play_again
  end

  def input_letter
    loop do
      letter = (prompt 'Please enter a letter as your guess OR 1 if you\'d like to save your progress: ').downcase

      if letter.length == 1 && letter.match(/[a-z]/) && valid_letter?(letter)
        break
      elsif letter == '1'
        @saved = true
        puts @saved
        save_game
        break
      end

      puts 'Invalid letter! Must be one letter only and it must not have been guessed previously!'
    end
  end

  def valid_letter?(letter)
    puts letter
    if @correct_guesses.include?(letter) || @incorrect_guesses.include?(letter)
      puts 'Invalid letter! Must be one letter only and it must not have been guessed previously!'
      false
    elsif @hidden_word.include?(letter)
      @hidden_word.each_with_index do |hidden_letter, i|
        @word_progress[i] = letter if hidden_letter == letter
      end
      @correct_guesses << letter
      puts 'Letter was correct! Nice!'
    else
      @incorrect_guesses << letter
      @guess_count -= 1
      puts 'Letter was incorrect! Oops...'
    end
    sleep 0.5
    true
  end

  def victory?
    @word_progress.include?('_') ? false : true
  end

  def save_game
    name = prompt 'Please enter a name for your saved file: '
    name = "saves/#{name}.yml"

    save = SaveFile.new(@hidden_word, @guess_count, @correct_guesses, @incorrect_guesses, @word_progress)

    Dir.mkdir('saves') unless Dir.exist?('saves')

    file = File.open(name, 'w')

    file.puts YAML.dump(save)

    puts "Save File #{name} created!"
  end

  def load_game
    begin
      name = prompt 'Please enter the name of your saved file: '
      name = "saves/#{name}.yml"

      clear
      raise "File #{name} not found!" unless File.exist?(name)
    rescue StandardError => e
      puts e
      retry
    end
    save_file = File.open(name, 'r')
    file = YAML.safe_load(save_file, permitted_classes: [SaveFile])
    save_file.close
    load_file(file)
  end

  def load_file(file)
    @hidden_word = file.hidden_word
    @guess_count = file.guess_count
    @correct_guesses = file.correct_guesses
    @incorrect_guesses = file.incorrect_guesses
    @word_progress = file.word_progress
    @saved = false

    play_game
  end

  def play_again
    answer = prompt 'Would you like to play again (Y/N)? '

    if answer.downcase == 'y'
      clear
      initialize
    else
      puts 'Thank you for playing! Goodbye!'
    end
  end

  def choose_word
    loop do
      word = File.readlines('words.txt').sample.chomp
      return word.split('') if word.length >= 5 && word.length <= 12
    end
  end
end

Hangman.new
