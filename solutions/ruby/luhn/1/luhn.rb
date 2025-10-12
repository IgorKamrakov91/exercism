=begin
Write your code for the 'Luhn' exercise in this file. Make the tests in
`luhn_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/luhn` directory.
=end
# Implements the Luhn algorithm for validating identification numbers
module Luhn
  def self.valid?(number)
    stripped = number.gsub(/\s/, '')
    return false if invalid_input?(stripped)

    checksum = calculate_checksum(stripped)
    (checksum % 10).zero?
  end

  private

  def self.invalid_input?(input)
    input.length <= 1 || input.match?(/\D/)
  end

  def self.calculate_checksum(input)
    input.chars.reverse.each_with_index.sum do |char, index|
      digit = char.to_i
      index.odd? ? double_and_adjust(digit) : digit
    end
  end

  def self.double_and_adjust(digit)
    doubled = digit * 2
    doubled > 9 ? doubled - 9 : doubled
  end
end
