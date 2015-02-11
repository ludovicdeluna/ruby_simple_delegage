module Warbuck
  module PotionForce

    def drink_potion_force
      puts Tools.to_underscore 'PotionForce'
      potion = Tools.to_underscore 'PotionForce'
      if @effects.include? potion
        printf "Poor hero. You have already drinked this. Please, wait now !\n"
      else
        @effects << potion
        @duration[potion.to_sym] = 3
        @stats_attack += 10
        printf "Your attack stats increased. Attack : %s pts\n", @stats_attack
      end
    end

    def left_potion_force
      potion = Tools.to_underscore 'PotionForce'
      if @effects.include? potion
        @effects.delete potion
        @stats_attack -=10
        printf "Your attack is now decreased. Attack : %s pts\n", @stats_attack
      else
        printf "You have already left this effects... Don't be creazy"
      end
    end

  end
end
