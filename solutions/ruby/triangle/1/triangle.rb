=begin
Write your code for the 'Triangle' exercise in this file. Make the tests in
`triangle_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/triangle` directory.
=end
class Triangle
  def initialize(list)
    @sides = list.sort
  end

  def equilateral?
    valid? && @sides.uniq.size == 1
  end

  def isosceles?
    valid? && @sides.uniq.size < 3
  end

  def scalene?
    valid? && @sides.uniq.size == 3
  end

  private

  def valid?
    @sides.all?(&:nonzero?) && triangle_equality?
  end

  def triangle_equality?
    a, b, c = @sides
    a + b >= c
  end
end
