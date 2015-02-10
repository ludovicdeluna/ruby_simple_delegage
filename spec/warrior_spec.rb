require 'spec_helper'

describe Warrior do
  let(:warrior) { Warrior.new }

  it { expect(warrior).to be_kind_of(Warrior) }

  it 'Hit with his sword make normal damages' do
    expect( warrior.hit ).to eq(Warrior.new.stats_attack)
  end

  context 'When warrior attempt to left his potion force effect' do
    before { warrior.left('PotionForce') }

    it 'did nothing (not already drinked)' do
      expect( warrior.hit ).to eq(Warrior.new.stats_attack)
    end
  end

  context 'When warrior drink a force potion' do
    before { warrior.drink('PotionForce') }

    it { expect(warrior.effects).to include(:potion_force) }

    it 'Force is increased' do
      expect( warrior.hit ).to be > Warrior.new.stats_attack
    end

    context 'When drink potion is out' do
      before { warrior.left('PotionForce') }

      it { expect(warrior.effects).not_to include(:potion_force) }

      it 'Force is normal' do
        expect( warrior.hit ).to eq(Warrior.new.stats_attack)
      end
    end
  end

  context 'When warrior drink a false potion' do
    it 'get no extra power' do
      expect( warrior.drink 'PotionJoke' ).to be(false)
    end
  end

end
