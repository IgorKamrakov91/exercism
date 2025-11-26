# Write your code for the 'Sum Of Multiples' exercise in this file. Make the tests in
# `sum_of_multiples_test.rb` pass.
#
# To get started with TDD, see the `README.md` file in your
# `ruby/sum-of-multiples` directory.
class SumOfMultiples
  def initialize(*multiples)
    @multiples = multiples
  end

  def to(number)
    (1...number).select do |num|
      @multiples.any? { |multiple| (num % multiple).zero? }
    end.sum
  end
end
