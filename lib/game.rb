module Warbuck
  class Game

    COMMANDS = %w|quit list scene stats|

    def initialize(hero=nil)
      clear
      @hero = hero || Warrior.new
      @turn_playing = 0
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
      puts @hero.list_actions
      puts COMMANDS
    end

    def console_quit
      @turn_playing = 0
      false
    end

    def console_stats
      @hero.stats
    end

    def gameover?
      @gameover ||= 'Sorry, your are dead' if @hero.stats_pv == 0
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
      begin
        @turn_playing += 1
        turn
      end until gameover?
      puts @gameover
    end

    def turn
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

