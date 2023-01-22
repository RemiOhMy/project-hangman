# frozen-string-literal: true

# Simplifies getting input from the user, and clearing the output screen.
module Common
  def prompt(args)
    print args
    gets.chomp
  end

  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end
end
