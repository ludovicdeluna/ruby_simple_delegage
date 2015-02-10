module PotionForce

  def drink_potion_force
    potion = method_with 'PotionForce'
    unless @effects.include? potion
      @effects << potion
      @stats_attack += 10
    end
  end

  def left_potion_force
    potion = method_with 'PotionForce'
    if @effects.include? potion
      @effects.delete potion
      @stats_attack -=10
    end
  end

end

