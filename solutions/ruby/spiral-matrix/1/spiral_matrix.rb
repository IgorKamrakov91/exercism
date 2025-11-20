# Write your code for the 'Spiral Matrix' exercise in this file. Make the tests in
# `spiraL_matrix_test.rb` pass.
#
# To get started with TDD, see the `README.md` file in your
# `ruby/spiral-matrix` directory.
class SpiralMatrix
  def initialize(size)
    @size = size
  end

  def matrix
    return [] if @size == 0

    number = @size**2 + 1
    result = []

    0.upto(@size * 2) do |m|
      previous = number
      number -= m / 2
      result = [[*number...previous], *result.reverse.transpose]
    end

    result
  end
end
