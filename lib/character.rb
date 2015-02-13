module Warbuck
  class Character

    attr_reader :stats, :name

    ALL_STATS = { attack:0, pv:0, effects:[], duration:{} }
    COMMANDS = []

    include Commands

    def initialize(name)
      init_stats
      load_stats my_class if defined? GAME_SETTINGS
      @name = name
    end

    def self.set_commands(commands)
      # Love metaprogramming
      send :const_set, *['COMMANDS', commands+COMMANDS]
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
