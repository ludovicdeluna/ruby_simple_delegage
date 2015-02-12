module Warbuck
  class Game

    COMMANDS = %w|stats scene list quit|

    def initialize(hero=nil)
      clear
      @hero = hero || Warrior.new
      start
    end

    def clear
      system "clear" or system "cls"
      STDOUT.flush
    end

    def console_do(action)
      if COMMANDS.include? action
        public_send "console_#{action.downcase}".to_sym
      else
        puts "I don't know what you mean !"
      end
    end

    def console_list
      puts @hero.class::ACTIONS
      puts COMMANDS
    end

    def console_quit
      @turn_playing = 0
      false
    end

    def console_stats
      @hero.show_stats
    end

    def gameover?
      @gameover ||= 'Sorry, your are dead' if @hero.stats.pv <= 0
      @gameover ||= 'You exit the game' if @turn_playing == 0
      @gameover ? true : false
    end

    def scene
      printf "Current turn : %s \n", @turn_playing
      puts 'You are in a castle'
    end

    alias :console_scene :scene

    def something
      print "What's now? (do something or list) "
      gets.chomp
    end

    def start
      @turn_playing = 0
      begin
        @turn_playing += 1
        turn
      end until gameover?
      puts @gameover
    end

    def turn
      @hero.decrease_effects
      scene
      whatsnow
    end

    def whatsnow
      loop do
        command = @hero.is_doing something
        if command
          break if (console_do command) == false
        else
          break
        end
      end
    end

  end
end

