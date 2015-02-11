module Warbuck
  require 'delegate'

  class Warrior

    attr_reader :stats_attack, :effects, :name, :stats_pv
    ACTIONS = %w|hit drink left killme|

    def initialize(name='Conan')
      @stats_attack = GAME_SETTINGS[:warrior][:attack] || 18
      @stats_pv = GAME_SETTINGS[:warrior][:pv] || 100
      @effects = []
      @name = name
      printf "A new warior is born : %s \n", @name
    end

    def is_doing(action)
      options = action.gsub(/\s+/m, ' ').strip.split(" ")
      todo = options.slice! 0
      return action until ACTIONS.include? todo

      if options.size > 0
        self.public_send "do_#{todo}", options
      else
        self.public_send "do_#{todo}"
      end

      nil
    end

    def do_killme
      puts 'You kill yourself'
      @stats_pv = 0
    end

    def do_hit
      puts 'You hit with your sword'
      return @stats_attack
    end

    def do_drink(potion=nil)
      potion &&= potion.first
      until potion
        puts "You want to drink but you can't remember his name... Shit !"
        return false
      end
      potion_name = potion
      potion = Module.const_get(potion) rescue nil
      if potion
        puts 'You drink a potion'
        self.extend(potion)
        printf "Woaw, it's a potion called %s\n", potion
        public_send( method_with "Drink" + potion.to_s )
        true
      else
        printf "You haven't this %s in your bag... Shame on you !\n", potion_name
      end
    end

    def do_left(potion=nil)
      potion &&= potion.first
      until potion
        puts "You think you can left a potion effect... But what was his name ?"
        return false
      end
      potion_name = potion
      potion = Module.const_get(potion) rescue nil
      if potion
        puts 'You will left a potion effect'
        method_with( "Left" + potion.to_s ).tap do |left_potion|
          public_send left_potion.to_sym if respond_to? left_potion.to_sym
        end
        true
      else
        printf "You think you have already drinked a %s... But not", potion_name
      end
    end

    def stats
      printf "PV : %s pts\n", @stats_pv
      printf "Attack : %s pts\n", @stats_attack
      printf "Effects : %s\n", @effects.join(', ')
    end

    def list_actions
      ACTIONS
    end

    def method_with(name)
      name.gsub(/([^\^])([A-Z])/,'\1_\2').downcase.to_sym
    end

  end
end
