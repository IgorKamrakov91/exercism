=begin
Write your code for the 'Raindrops' exercise in this file. Make the tests in
`raindrops_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/raindrops` directory.
=end
class Raindrops
  def self.convert(value)
    result = ''
    result += 'Pling' if (value % 3).zero?
    result += 'Plang' if (value % 5).zero?
    result += 'Plong' if (value % 7).zero?
    result.empty? ? value.to_s : result
  end
end
