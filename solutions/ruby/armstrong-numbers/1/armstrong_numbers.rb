module ArmstrongNumbers
  def self.include?(number)
    number.digits.sum { |num| num**number.digits.size } == number
  end
end
