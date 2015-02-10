class Warrior

  attr_reader :stats_attack
  attr_reader :effects

  def initialize
    @stats_attack = 18
    @effects = []
  end

  def hit
    return @stats_attack
  end

  def drink(potion)
    potion = Module.const_get(potion) rescue nil
    if potion
      self.extend(potion)
      public_send( method_with "Drink" + potion.to_s )
      true
    else false
    end
  end

  def left(potion)
    potion = Module.const_get(potion) rescue nil
    if potion
      method_with( "Left" + potion.to_s ).tap do |left_potion|
        public_send left_potion.to_sym if respond_to? left_potion.to_sym
      end
    end
  end

  def method_with(name)
    name.gsub(/([^\^])([A-Z])/,'\1_\2').downcase.to_sym
  end

end
