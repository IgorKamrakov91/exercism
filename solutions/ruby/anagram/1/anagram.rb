=begin
Write your code for the 'Anagram' exercise in this file. Make the tests in
`anagram_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/anagram` directory.
=end
class Anagram
  def initialize(string)
    @string = string
  end

  def match(array)
    array.select do |word|
      next if @string.downcase == word.downcase

      @string.downcase.chars.sort == word.downcase.chars.sort
    end
  end
end
