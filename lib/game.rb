module Warbuck
  class Game

    COMMANDS = %w|stats scene list quit|

    include Commands

    def initialize(hero=nil)
      clear
      @hero = hero || Warrior.new
      start
    end

    def clear
      system "clear" or system "cls"
      STDOUT.flush
    end

    def do_list
      puts @hero.class::COMMANDS
      puts COMMANDS
    end

    def do_quit
      @turn_playing = 0
      :quit
    end

    def do_stats
      @hero.show_stats
    end

    def gameover?
      @gameover ||= 'Sorry, your are dead' unless @hero.stats.pv > 0
      @gameover ||= 'You exit the game' unless @turn_playing > 0
      @gameover ? true : false
    end

    def need_repeat(command)
      case does(command)
      when :unknown then
        puts "I don't know what you mean !"
      when :quit then
        return false
      end
      true
    end

    def scene
      printf "Current turn : %s \n", @turn_playing
      puts 'You are in a castle'
    end
    alias :do_scene :scene

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
      begin
        command = @hero.is_doing something
      end while command && need_repeat(command)
    end

  end
end

