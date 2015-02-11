module Warbuck
  require 'delegate'

  class Warrior < Character

    attr_reader :stats_attack, :effects, :name, :stats_pv
    ACTIONS = %w|hit drink left killme|

    def initialize(name='Conan')
      @stats_attack = GAME_SETTINGS[:warrior][:attack] || 18
      @stats_pv = GAME_SETTINGS[:warrior][:pv] || 100
      @effects = []
      @duration = {}
      @name = name
      printf "A new warrior is born : %s \n", @name
    end

    def is_doing(something)
      action, options = Tools.split_whatsnow(something)
      return something until ACTIONS.include? action

      if options.empty?
        self.public_send("do_#{action}") rescue learn_this action
      else
        self.public_send("do_#{action}", *options) rescue learn_this action
      end

      nil
    end

    def learn_this(action)
      printf "Woooo... Please, learn to use %s\n", action
    end

    def do_killme
      puts 'You kill yourself'
      @stats_pv = 0
    end

    def do_hit(ennemy=nil)
      if ennemy == 'me'
        puts 'You raise your sword and...'
        do_killme
      else
        puts 'You hit with your sword'
        return @stats_attack
      end
    end

    def do_drink(potion=nil)
      until potion
        puts "You want to drink but you can't remember his name... Shit !"
        return false
      end
      potion_object = Tools.camelcase_to_module(potion)
      if potion_object
        printf "You drink a potion : %s\n", potion
        self.extend(potion_object)
        public_send Tools.camelcase_to_method('Drink' + potion)
        true
      else
        printf "You haven't this %s in your bag... Shame on you !\n", potion
      end
    end

    def do_left(potion=nil)
      until potion
        puts "You think you can left a potion effect... But what was his name ?"
        return false
      end
      potion_object = Tools.camelcase_to_module(potion)
      if potion_object
        puts 'You will left a potion effect'
        public_send Tools.to_underscore("Left" + potion.to_s)
        Tools.to_underscore( "Left" + potion.to_s ).tap do |left_potion|
          public_send left_potion.to_sym if respond_to? left_potion.to_sym
        end
        true
      else
        printf "You think you have already drinked a %s... But not", potion_name
      end
    end

    def decrease_effects
      @effects.each do |effect|
        if @duration[effect.to_sym] == 0
          do_left ['PotionForce']
        else
          @duration[effect.to_sym] -= 1
        end
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

  end
end
