=begin
Write your code for the 'D&D Character' exercise in this file. Make the tests in
`dnd_character_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/dnd-character` directory.
=end

class DndCharacter
  attr_reader :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :hitpoints

  def initialize
    @strength = generate_ability_score
    @dexterity = generate_ability_score
    @constitution = generate_ability_score
    @intelligence = generate_ability_score
    @wisdom = generate_ability_score
    @charisma = generate_ability_score
    @hitpoints = 10 + self.class.modifier(@constitution)
  end

  def self.modifier(score)
    (score - 10) / 2
  end

  private

  def generate_ability_score
    rolls = Array.new(4) { rand(1..6) }
    rolls.sort.last(3).sum
  end
end
