module Warbuck
  class Character < Commandable

    attr_reader :stats, :name
    ALL_STATS = { attack:0, pv:0, effects:[], duration:{} }

    def initialize(name)
      init_stats
      load_stats my_class if defined? GAME_SETTINGS
      @name = name
    end

    def show_stats
      @stats.each_pair do |key, value|
        printf "%s : %s", key.to_s.upcase, value
        printf " pts" unless [Array, Hash].include? value.class
        printf "\n"
      end
    end

    def my_class
      Tools.to_underscore self.class.name.split('::').last
    end

    def decrease_effects
      @stats.effects.each do |effect|
        if @stats.duration[effect.to_sym] == 0
          do_left ['PotionForce']
        else
          @duration[effect.to_sym] -= 1
        end
      end
    end

    def do_describe(what='nothing')
      public_send "describe_#{what}"
    end

    def describe_nothing
      puts 'Please, tell me what you want I describe !'
    end

    def describe_me
      puts 'Hello you ! This is a generic Character action'
    end


    private

    def init_stats
      @stats = Struct.new(*ALL_STATS.keys).new.tap do |stats|
        ALL_STATS.each {|key, value| stats[key] = value}
      end
    end

    def load_stats(classname)
      GAME_SETTINGS[classname.to_sym].each {|key, value| @stats[key] = value }
    end

  end
end
